//
//  FirestoreChatRepository.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 12/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CodableFirebase
import FirebaseStorage
import RxSwift
import RxSwiftExt

private enum Keys {
    static let conversations = "conversations"
}

protocol FirestoreChatRepository: AnyObject {
    func getConversations(for ids: [String]) -> Observable<[Conversation?]>
    func setConversation(conversation: Conversation, userId: String)
    func send(message: FirebaseChatMessage, to conversationId: String) -> Observable<Bool>
    func listen(to conversationId: String) -> Observable<[FirebaseChatMessage]>
    func getImage(for url: String) -> Observable<UIImage?>
}

final class FirestoreChatRepositoryImpl: FirestoreChatRepository {

    private let firestore: Firestore
    private let storage: Storage
    private let conversationsRef: CollectionReference
    private let decoder: FirebaseDecoder
    private let encoder: FirebaseEncoder
    private var uploadSubscription: Disposable?

    init(firestore: Firestore, storage: Storage, decoder: FirebaseDecoder, encoder: FirebaseEncoder) {
        self.firestore = firestore
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
        conversationsRef = firestore.collection(Keys.conversations)
    }

    func getConversations(for ids: [String]) -> Observable<[Conversation?]> {
        return Observable.from(ids.map { self.getConversation(for: $0) })
            .merge()
            .toArray()
            .asObservable()
    }

    func setConversation(conversation: Conversation, userId: String) {

    }

    func send(message: FirebaseChatMessage, to conversationId: String) -> Observable<Bool> {
        return getConversation(for: conversationId)
            .flatMap { self.updateConversation(message: message, conversation: $0, conversationId: conversationId) }
    }

    func listen(to conversationId: String) -> Observable<[FirebaseChatMessage]> {
        let documentRef = conversationsRef.document(conversationId)
        return Observable.create { observer in
            documentRef.addSnapshotListener { (documentSnapshot, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                    observer.onError(error)
                    return
                }
                guard let document = documentSnapshot,
                    let data = document.data() else {
                        print("Document data was empty.")
                        observer.onNext([])
                        return
                }
                do {
                    let conversation = try self.decoder.decode(Conversation.self, from: data)
                    observer.onNext(conversation.messages)
                } catch {
                    print(error.localizedDescription)
                }
            }
            return Disposables.create()
        }
    }

    func getImage(for url: String) -> Observable<UIImage?> {
        let imageReference = storage.reference(forURL: url)
        let megaBytes = Int64(10 * 1024 * 1024)
        return Observable.create { observer in
            imageReference.getData(maxSize: megaBytes) { (data, error) in
                if let error = error {
                    observer.onError(error)
                }
                guard let data = data else {
                    print("No image data at given url")
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }
                observer.onNext(UIImage(data: data))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    private func getConversation(for conversationId: String) -> Observable<Conversation?> {
        let documentRef = conversationsRef.document(conversationId)
        return Single<Conversation?>.create { single in
            documentRef.getDocument { (documentSnapshot, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                    single(.error(error))
                    return
                }
                guard let document = documentSnapshot,
                    let data = document.data() else {
                        print("Document data was empty.")
                        single(.success(nil))
                        return
                }
                do {
                    let conversation = try self.decoder.decode(Conversation.self, from: data)
                    single(.success(conversation))
                } catch {
                    print(error.localizedDescription)
                }
            }
            return Disposables.create()
        }.asObservable()
    }

    private func updateConversation(message: FirebaseChatMessage, conversation: Conversation?, conversationId: String) -> Observable<Bool> {
        if let image = message.image {
            return upload(image: image, conversationId: conversationId).flatMap { url in
                return self.updateImageDownloadUrl(message: message, url: url, conversation: conversation, conversationId: conversationId)
            }
        } else {
            return self.addMessageToConversation(message: message, conversation: conversation, conversationId: conversationId)
        }
    }

    private func upload(image: UIImage, conversationId: String) -> Observable<URL> {
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return Observable.empty()
        }

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let storageRef = storage.reference()
        let imageRef = storageRef.child(conversationId).child(imageName)
        return Observable.create { observer in
            imageRef.putData(imageData, metadata: metadata) { _, error in
                if let error = error {
                    observer.onError(error)
                }
                imageRef.downloadURL { (url, error) in
                    if let error = error {
                        observer.onError(error)
                    }
                    guard let url = url else {
                        print("No image download url")
                        observer.onCompleted()
                        return
                    }
                    observer.onNext(url)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    private func updateImageDownloadUrl(message: FirebaseChatMessage,
                                        url: URL,
                                        conversation: Conversation?,
                                        conversationId: String) -> Observable<Bool> {
        message.imageUrl = url.absoluteString
        return addMessageToConversation(message: message, conversation: conversation, conversationId: conversationId)
    }

    private func addMessageToConversation(message: FirebaseChatMessage, conversation: Conversation?, conversationId: String) -> Observable<Bool> {
        if let conversation = conversation {
            conversation.messages.append(message)
            return self.save(conversation: conversation)
        } else {
            let conversation = Conversation(conversationId: conversationId, messages: [message])
            return self.save(conversation: conversation)
        }
    }

    private func save(conversation: Conversation) -> Observable<Bool> {
        return Observable.create { observer in
            let documentRef = self.conversationsRef.document(conversation.conversationId)
            do {
                guard let conversationData = try self.encoder.encode(conversation) as? [String: Any] else {
                    observer.onNext(false)
                    observer.onCompleted()
                    return Disposables.create()
                }
                documentRef.setData(conversationData) { error in
                    if let error = error {
                        observer.onError(error)
                    }
                    observer.onNext(true)
                    observer.onCompleted()
                }
            } catch {
                print(error.localizedDescription)
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

}

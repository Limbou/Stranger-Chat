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
}

final class FirestoreChatRepositoryImpl: FirestoreChatRepository {

    private let firestore: Firestore
    private let conversationsRef: CollectionReference
    private let decoder: FirebaseDecoder
    private let encoder: FirebaseEncoder

    init(firestore: Firestore, decoder: FirebaseDecoder, encoder: FirebaseEncoder) {
        self.firestore = firestore
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

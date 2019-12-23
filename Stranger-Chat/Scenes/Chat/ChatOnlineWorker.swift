//
//  FirebaseChatWorker.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 12/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseFirestore
import MultipeerConnectivity

protocol ChatOnlineWorker: AnyObject {
    var receivedMessages: PublishSubject<[ChatMessage]> { get }
    var disconnected: PublishSubject<Void> { get }
    func initializeConnection()
    func getOtherUserName() -> String
    func send(message: String)
    func send(image: UIImage)
    func disconnectFromSession()
}

final class ChatOnlineWorkerImpl: ChatOnlineWorker {

    private let peerConnection: PeerConnection
    private let chatRepository: FirestoreChatRepository
    private let userRepository: FirebaseUsersRepository
    private let firestoreUserRepository: FirestoreUsersRepository
    private var conversationId: String = ""
    private var userId: String = ""
    let receivedMessages = PublishSubject<[ChatMessage]>()
    let disconnected = PublishSubject<Void>()
    let bag = DisposeBag()

    init(peerConnection: PeerConnection,
         chatRepository: FirestoreChatRepository,
         userRepository: FirebaseUsersRepository,
         firestoreUserRepository: FirestoreUsersRepository) {
        self.peerConnection = peerConnection
        self.chatRepository = chatRepository
        self.userRepository = userRepository
        self.firestoreUserRepository = firestoreUserRepository
        self.peerConnection.delegate = self
    }

    func initializeConnection() {
        guard conversationId == "",
            peerConnection as? PeerHostSession != nil else {
            return
        }
        let newConversationId = UUID().uuidString
        conversationId = newConversationId
        let secretConversationIdMessage = ChatSecretMessages.conversationId.rawValue + newConversationId
        guard let messageData = secretConversationIdMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            print("Error converting message")
            return
        }
        peerConnection.send(data: messageData)
        chatRepository.listen(to: conversationId).flatMap { firebaseMessages in
            return self.convertToChatMessages(firebaseMessages)
        }
        .bind(to: receivedMessages)
        .disposed(by: bag)

        updateUserConverstaions(conversationId: conversationId)
    }

    func getOtherUserName() -> String {
        guard let peer = peerConnection.mcSession.connectedPeers.first else {
            return ""
        }
        return peer.displayName
    }

    func send(message: String) {
        guard let userId = userRepository.currentUser()?.uid else {
            print("User is gone")
            return
        }
        let chatMessage = FirebaseChatMessage(senderId: userId, content: message)
        chatRepository.send(message: chatMessage, to: conversationId).subscribe(onNext: { success in
            print(success)
        }, onError: { error in
            print(error)
        }).disposed(by: bag)
    }

    func send(image: UIImage) {
        guard let userId = userRepository.currentUser()?.uid else {
            print("User is gone")
            return
        }
        let chatMessage = FirebaseChatMessage(senderId: userId, image: image)
        chatRepository.send(message: chatMessage, to: conversationId).subscribe(onNext: { success in
            print(success)
        }, onError: { error in
            print(error)
        }).disposed(by: bag)
    }

    func disconnectFromSession() {

    }

    private func handleConverstaionIdMessage(_ message: String) {
        guard let indexOfEqualSign = message.firstIndex(of: "=") else {
            return
        }
        let indexAfterEqualSign = message.index(after: indexOfEqualSign)
        let idSubstring = message[indexAfterEqualSign...]
        conversationId = "\(idSubstring)"
        chatRepository.listen(to: conversationId).flatMap { firebaseMessages in
            return self.convertToChatMessages(firebaseMessages)
        }
        .bind(to: receivedMessages)
        .disposed(by: bag)

        updateUserConverstaions(conversationId: conversationId)
    }

    private func updateUserConverstaions(conversationId: String) {
        guard let userId = userRepository.currentUser()?.uid else {
            return
        }
        firestoreUserRepository.getData(for: userId).flatMap { user -> Observable<Bool> in
            guard let user = user else {
                return Observable.just(false)
            }
            user.chatsIds.append(conversationId)
            return self.firestoreUserRepository.setUserData(appUser: user)
        }
        .subscribe(onNext: { _ in })
        .disposed(by: bag)
    }

    private func convertToChatMessages(_ messages: [FirebaseChatMessage]) -> Observable<[ChatMessage]> {
        let userId = self.userRepository.currentUser()?.uid ?? ""
        return Observable.from(messages.map { self.convertToSingleChatMessage($0, userId: userId) })
            .merge()
            .toArray()
            .asObservable()
    }

    private func convertToSingleChatMessage(_ message: FirebaseChatMessage, userId: String) -> Observable<ChatMessage> {
        if let imageUrl = message.imageUrl {
            return self.downloadImageFor(urlString: imageUrl).map { image in
                return ChatMessage(image: image, isAuthor: message.senderId == userId)
            }
        }
        return Observable.just(ChatMessage(content: message.content, isAuthor: message.senderId == userId))
    }

    private func downloadImageFor(urlString: String) -> Observable<UIImage?> {
        return chatRepository.getImage(for: urlString)
    }

}

extension ChatOnlineWorkerImpl: PeerSessionDelegate {

    func peerReceived(data: Data, from peerID: MCPeerID) {
        guard let message = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? else {
            print("Error converting data to message")
            return
        }
        if message.contains(ChatSecretMessages.conversationId.rawValue) {
            handleConverstaionIdMessage(message)
        }
    }

    func peerDisconnected(peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.disconnected.onNext(())
        }
    }

    func peerConnectionError(_ error: Error) {
        print("Failed to send data")
        print(error.localizedDescription)
    }

}

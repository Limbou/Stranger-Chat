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

final class FirebaseChatWorker: ChatWorker {

    private let peerConnection: PeerConnection
    private let chatRepository: FirestoreChatRepository
    private let userRepository: FirebaseUsersRepository
    private var conversationId: String = ""
    private var userId: String = ""
    let receivedMessages = PublishSubject<ChatMessage>()
    let receivedMessagesArray = PublishSubject<[ChatMessage]>()
    let disconnected = PublishSubject<Void>()
    let bag = DisposeBag()

    init(peerConnection: PeerConnection, chatRepository: FirestoreChatRepository, userRepository: FirebaseUsersRepository) {
        self.peerConnection = peerConnection
        self.chatRepository = chatRepository
        self.userRepository = userRepository
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
        chatRepository.listen(to: conversationId).map { firebaseMessages in
            let userId = self.userRepository.currentUser()?.uid ?? ""
            return firebaseMessages.map { ChatMessage(content: $0.content, isAuthor: $0.senderId == userId) }
        }
        .bind(to: receivedMessagesArray)
        .disposed(by: bag)
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
        chatRepository.listen(to: conversationId).map { firebaseMessages in
            let userId = self.userRepository.currentUser()?.uid ?? ""
            return firebaseMessages.map { ChatMessage(content: $0.content, isAuthor: $0.senderId == userId) }
        }
        .bind(to: receivedMessagesArray)
        .disposed(by: bag)
    }

}

extension FirebaseChatWorker: PeerSessionDelegate {

    func peerReceived(data: Data, from peerID: MCPeerID) {
        guard let message = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? else {
            print("Error converting data to message")
            return
        }
        if message.contains(ChatSecretMessages.conversationId.rawValue) {
            handleConverstaionIdMessage(message)
            return
        }
        let chatMessage = ChatMessage(content: message, isAuthor: false)
        DispatchQueue.main.async {
            self.receivedMessages.onNext(chatMessage)
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

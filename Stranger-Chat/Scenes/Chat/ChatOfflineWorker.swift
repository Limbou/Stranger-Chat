//
//  ChatWorker.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 08/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation
import RxSwift
import MultipeerConnectivity

protocol ChatOfflineWorker: AnyObject {
    var receivedMessages: PublishSubject<ChatMessage> { get }
    var disconnected: PublishSubject<Void> { get }
    func getOtherUserName() -> String
    func send(message: String)
    func send(image: UIImage, messageId: String) -> String?
    func save(conversation: LocalConversation)
    func disconnectFromSession()
}

final class ChatOfflineWorkerImpl: ChatOfflineWorker {

    private let peerConnection: PeerConnection
    private let fileManager: FileManager
    private let localConversationRepository: LocalConversationRepository
    let receivedMessages = PublishSubject<ChatMessage>()
    let receivedMessagesArray = PublishSubject<[ChatMessage]>()
    let disconnected = PublishSubject<Void>()

    init(peerConnection: PeerConnection,
         fileManager: FileManager,
         localConversationRepository: LocalConversationRepository) {
        self.peerConnection = peerConnection
        self.fileManager = fileManager
        self.localConversationRepository = localConversationRepository
        self.peerConnection.delegate = self
    }

    func getOtherUserName() -> String {
        guard let peer = peerConnection.mcSession.connectedPeers.first else {
            return ""
        }
        return peer.displayName
    }

    func send(message: String) {
        guard let messageData = message.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            print("Error converting message")
            return
        }
        peerConnection.send(data: messageData)
    }

    func send(image: UIImage, messageId: String) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1),
            let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
            let peer = peerConnection.mcSession.connectedPeers.first else {
                print("Error sending image")
                return nil
        }
        let photoURL = path.appendingPathComponent("\(messageId).jpg")
        do {
            try imageData.write(to: photoURL)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        let progress = self.peerConnection.sendResource(at: photoURL, withName: "\(messageId).jpg", toPeer: peer) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return photoURL.path
    }

    func save(conversation: LocalConversation) {
        localConversationRepository.save(conversation: conversation)
    }

    func disconnectFromSession() {
        peerConnection.reset()
    }

    private func tryToGetImageFrom(url: URL) {
        do {
            let localData = try Data(contentsOf: url)
            guard let image = UIImage(data: localData) else {
                print("Error geting image from data")
                return
            }
            let chatMessage = ChatMessage(image: image, isAuthor: false)
            let imagePath = saveImage(data: localData, name: chatMessage.messageId)
            chatMessage.imagePath = imagePath
            DispatchQueue.main.async {
                self.receivedMessages.onNext(chatMessage)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private func saveImage(data: Data, name: String) -> String? {
        guard let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let photoURL = path.appendingPathComponent("\(name).jpg")
        do {
            try data.write(to: photoURL)
            return photoURL.path
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}

extension ChatOfflineWorkerImpl: PeerSessionDelegate {

    func peerReceived(data: Data, from peerID: MCPeerID) {
        guard let message = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? else {
            print("Error converting data to message")
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

    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) {
        if let url = localURL {
            tryToGetImageFrom(url: url)
        }
    }

}

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

private enum MessageKeys {
    static let messsage = "message"
    static let senderId = "senderId"
}

protocol ChatOfflineWorker: AnyObject {
    var receivedMessages: PublishSubject<ChatMessage> { get }
    var disconnected: PublishSubject<Void> { get }
    func createChatMessageWith(content: String?, image: UIImage?) -> ChatMessage?
    func getOtherUserName() -> String
    func send(message: String)
    func getImagePath(messageId: String) -> String?
    func send(image: UIImage, messageId: String) -> Observable<Double?>
    func save(conversation: LocalConversation)
    func disconnectFromSession()
}

final class ChatOfflineWorkerImpl: ChatOfflineWorker {

    private let peerConnection: PeerConnection
    private let fileManager: FileManager
    private let localConversationRepository: LocalConversationRepository
    private let currentUserRepository: CurrentUserRepository
    let receivedMessages = PublishSubject<ChatMessage>()
    let receivedMessagesArray = PublishSubject<[ChatMessage]>()
    let disconnected = PublishSubject<Void>()

    init(peerConnection: PeerConnection,
         fileManager: FileManager,
         localConversationRepository: LocalConversationRepository,
         currentUserRepository: CurrentUserRepository) {
        self.peerConnection = peerConnection
        self.fileManager = fileManager
        self.localConversationRepository = localConversationRepository
        self.currentUserRepository = currentUserRepository
        self.peerConnection.delegate = self
    }

    func createChatMessageWith(content: String?, image: UIImage?) -> ChatMessage? {
        guard let senderId = currentUserRepository.currentUser()?.userId else {
            print("No user")
            return nil
        }
        return ChatMessage(content: content, image: image, senderId: senderId)
    }

    func getOtherUserName() -> String {
        guard let peer = peerConnection.mcSession.connectedPeers.first else {
            return ""
        }
        return peer.displayName
    }

    func send(message: String) {
        guard let senderId = currentUserRepository.currentUser()?.userId else {
            print("No user")
            return
        }
        var messageDict = [String: String]()
        messageDict[MessageKeys.messsage] = message
        messageDict[MessageKeys.senderId] = senderId
        do {
            let messageData = try JSONSerialization.data(withJSONObject: messageDict, options: .prettyPrinted)
            peerConnection.send(data: messageData)
        } catch {
            print(error.localizedDescription)
        }
    }

    func getImagePath(messageId: String) -> String? {
        guard let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let imagePath = path.appendingPathComponent("\(messageId).jpg")
        return imagePath.path
    }

    func send(image: UIImage, messageId: String) -> Observable<Double?> {
        guard let imageData = image.jpegData(compressionQuality: 1),
            let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
            let peer = peerConnection.mcSession.connectedPeers.first else {
                print("Error sending image")
                return Observable.empty()
        }
        let photoURL = path.appendingPathComponent("\(messageId).jpg")
        do {
            try imageData.write(to: photoURL)
        } catch {
            print(error.localizedDescription)
            return Observable.error(error)
        }
        let progress = self.peerConnection.sendResource(at: photoURL, withName: "\(messageId).jpg", toPeer: peer) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        if let progress = progress {
           return progress.rx.observe(Double.self, "fractionCompleted")
        }
        return Observable.empty()
    }

    func save(conversation: LocalConversation) {
        localConversationRepository.save(conversation: conversation)
    }

    func disconnectFromSession() {
        peerConnection.disconnect()
    }

    private func tryToGetImageFrom(url: URL) {
        do {
            let localData = try Data(contentsOf: url)
            guard let image = UIImage(data: localData) else {
                print("Error geting image from data")
                return
            }
            let chatMessage = ChatMessage(image: image, senderId: "1")
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
        do {
            guard let messageJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: String],
                let content = messageJson[MessageKeys.messsage],
                let senderId = messageJson[MessageKeys.senderId] else {
                print("Error parsing json")
                return
            }
            let chatMessage = ChatMessage(content: content, senderId: senderId)
            DispatchQueue.main.async {
                self.receivedMessages.onNext(chatMessage)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func peerDisconnected(peerID: MCPeerID) {
        print("Disconnected: \(peerID.displayName)")
        self.disconnected.onNext(())
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

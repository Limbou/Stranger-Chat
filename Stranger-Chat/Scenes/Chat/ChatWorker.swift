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

protocol ChatWorker: AnyObject {
    var receivedMessages: PublishSubject<ChatMessage> { get }
    var receivedMessagesArray: PublishSubject<[ChatMessage]> { get }
    var disconnected: PublishSubject<Void> { get }
    func initializeConnection()
    func send(message: String)
    func send(image: UIImage)
    func disconnectFromSession()
}

extension ChatWorker {
    func initializeConnection() {}
}

final class ChatWorkerImpl: ChatWorker {

    private let peerConnection: PeerConnection
    private let fileManager: FileManager
    let receivedMessages = PublishSubject<ChatMessage>()
    let receivedMessagesArray = PublishSubject<[ChatMessage]>()
    let disconnected = PublishSubject<Void>()

    init(peerConnection: PeerConnection, fileManager: FileManager) {
        self.peerConnection = peerConnection
        self.fileManager = fileManager
        self.peerConnection.delegate = self
    }

    func send(message: String) {
        guard let messageData = message.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            print("Error converting message")
            return
        }
        peerConnection.send(data: messageData)
    }

    func send(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1),
            let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
            let peer = peerConnection.mcSession.connectedPeers.first else {
                print("Error sending image")
                return
        }
        let imageId = UUID().uuidString
        let photoURL = path.appendingPathComponent("\(imageId).png")
        do {
            try imageData.write(to: photoURL)
        } catch {
            print(error.localizedDescription)
            return
        }
        peerConnection.sendResource(at: photoURL, withName: "\(imageId).png", toPeer: peer) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
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
            DispatchQueue.main.async {
                self.receivedMessages.onNext(chatMessage)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

}

extension ChatWorkerImpl: PeerSessionDelegate {

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

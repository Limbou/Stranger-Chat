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
    var receivedMessages: PublishSubject<String> { get }
    var disconnected: PublishSubject<Void> { get }
    func send(message: String)
    func send(image: UIImage)
    func disconnectFromSession()
}

final class ChatWorkerImpl: ChatWorker {

    private let peerConnection: PeerConnection
    let receivedMessages = PublishSubject<String>()
    let disconnected = PublishSubject<Void>()

    init(peerConnection: PeerConnection) {
        self.peerConnection = peerConnection
        self.peerConnection.delegate = self
    }

    func send(message: String) {
        guard let messageData = message.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            print("Error converting message")
            return
        }
        print(peerConnection.mcSession.connectedPeers)
        peerConnection.send(data: messageData)
    }

    func send(image: UIImage) {
        guard let imageData = image.pngData() else { return }
        let fileManager = FileManager.default
        let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let photoURL = path.appendingPathComponent("image.png")
        do {
            try imageData.write(to: photoURL)
        } catch {
            print(error.localizedDescription)
        }

        peerConnection.sendResource(at: photoURL, withName: "image.png", toPeer: peerConnection.mcSession.connectedPeers[0]) { error in
            print(error?.localizedDescription)
        }
    }

    func disconnectFromSession() {
        peerConnection.reset()
    }

}

extension ChatWorkerImpl: PeerSessionDelegate {

    func peerReceived(data: Data, from peerID: MCPeerID) {
        guard let message = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? else {
            print("Error converting data to message")
            return
        }
        DispatchQueue.main.async {
            self.receivedMessages.onNext(message)
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

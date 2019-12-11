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
    private let fileManager: FileManager
    let receivedMessages = PublishSubject<String>()
    let disconnected = PublishSubject<Void>()

    init(peerConnection: PeerConnection, fileManager: FileManager) {
        self.peerConnection = peerConnection
        self.fileManager = fileManager
        self.peerConnection.delegate = self
    }

    func send(message: String) {
        print(peerConnection)
        guard let messageData = message.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            print("Error converting message")
            return
        }
        print(peerConnection.mcSession.connectedPeers)
        peerConnection.send(data: messageData)
    }

    func send(image: UIImage) {
        guard let imageData = image.pngData(),
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
        print("Disconnected")
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
            do {
                let localData = try Data(contentsOf: url)
                let image = UIImage(data: localData)
                print(image?.isSymbolImage)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

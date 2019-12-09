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
    func send(message: String)
    func disconnectFromSession()
}

final class ChatWorkerImpl: ChatWorker {

    private let peerConnection: PeerConnection
    let receivedMessages = PublishSubject<String>()

    init(peerConnection: PeerConnection) {
        self.peerConnection = peerConnection
        self.peerConnection.delegate = self
    }

    func send(message: String) {
        guard let messageData = message.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            print("Error converting message")
            return
        }
        peerConnection.send(data: messageData)
    }

    func disconnectFromSession() {
        peerConnection.mcSession.disconnect()
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

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connecting:
            print("Connecting")
        case .connected:
            print("Connected")
        case .notConnected:
            print("Disconnected")
        default:
            break
        }
    }

    func peerConnectionError(_ error: Error) {
        print("Failed to send data")
        print(error.localizedDescription)
    }

}

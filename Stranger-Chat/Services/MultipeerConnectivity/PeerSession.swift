//
//  PeerSession.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 16/04/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol PeerSessionDelegate: AnyObject {
    func peerConnected(peerID: MCPeerID)
    func peerConnecting(peerID: MCPeerID)
    func peerDisconnected(peerID: MCPeerID)
    func peerDiscovered(peerID: MCPeerID)
    func peerLost(peerID: MCPeerID)
    func peerReceived(data: Data, from peerID: MCPeerID)
    func peerConnectionError(_ error: Error)
    func connectionReady()
    func connectionClosed()
    func invitationReceived(from peerID: MCPeerID,
                            context: Data?,
                            invitationHandler: @escaping (Bool, MCSession?) -> Void)
}

protocol PeerConnection {
    var mcSession: MCSession? { get }
    var delegate: PeerSessionDelegate? { get set }
    func connect()
    func disconnect()
    func send(data: Data)
    func send(data: Data, to peerIDs: [MCPeerID])
}

extension PeerConnection {

    func send(data: Data) {
        self.send(data: data, to: self.mcSession?.connectedPeers ?? [])
    }

    func send(data: Data, to peerIDs: [MCPeerID]) {
        do {
            try self.mcSession?.send(data, toPeers: peerIDs, with: MCSessionSendDataMode.reliable)
        } catch let error {
            self.delegate?.peerConnectionError(error)
        }
    }

}

extension PeerSessionDelegate {
    func peerConnected(peerID: MCPeerID) {}
    func peerConnecting(peerID: MCPeerID) {}
    func peerDisconnected(peerID: MCPeerID) {}
    func peerDiscovered(peerID: MCPeerID) {}
    func peerLost(peerID: MCPeerID) {}
    func peerReceived(data: Data, from peerID: MCPeerID) {}
    func peerConnectionError(_ error: Error) {}
    func connectionReady() {}
    func connectionClosed() {}
    func invitationReceived(from peerID: MCPeerID,
                            context: Data?,
                            invitationHandler: @escaping (Bool, MCSession?) -> Void) {}
}

let peerServiceType = "strangerChat"

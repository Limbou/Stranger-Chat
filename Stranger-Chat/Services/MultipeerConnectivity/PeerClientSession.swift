//
//  PeerClientSession.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 16/04/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class PeerClientSession: NSObject, PeerConnection, MCNearbyServiceAdvertiserDelegate {

    let mcSession: MCSession
    var advertiser: MCNearbyServiceAdvertiser?
    let peerId: MCPeerID
    var sessionHandler: MCSessionAdapter?
    weak var delegate: PeerSessionDelegate?

    required init(displayName: String) {
        let peerdId = MCPeerID(displayName: displayName)
        self.peerId = peerdId
        let session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        self.mcSession = session
        super.init()
    }

    func connect() {
        self.disconnect()

        let sessionHandler = MCSessionAdapter()
        sessionHandler.setSession(self.mcSession)
        sessionHandler.delegate = self.delegate
        self.sessionHandler = sessionHandler

        let advertiser = MCNearbyServiceAdvertiser(peer: self.peerId, discoveryInfo: nil, serviceType: peerServiceType)
        advertiser.delegate = self
        self.advertiser = advertiser
        advertiser.startAdvertisingPeer()
    }

    func disconnect() {
        self.advertiser?.stopAdvertisingPeer()
        self.mcSession.disconnect()
        self.sessionHandler = nil
        self.mcSession.disconnect()
        self.delegate?.connectionClosed()
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Swift.Error) {
        self.delegate?.peerConnectionError(error)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Before invitation handler - \(mcSession.connectedPeers)")
        invitationHandler(true, self.mcSession)
        print("After invitation handler - \(mcSession.connectedPeers)")
        self.delegate?.invitationReceived(from: peerID)
    }

}

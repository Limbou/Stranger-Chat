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

    static let shared = PeerClientSession()
    var mcSession: MCSession?
    var advertiser: MCNearbyServiceAdvertiser?
    var peerId: MCPeerID?
    var sessionHandler: MCSessionAdapter?
    var displayName: String? {
        didSet(newName) {
            initialize(displayName: newName)
        }
    }
    weak var delegate: PeerSessionDelegate? {
        didSet(newValue) {
            sessionHandler?.delegate = newValue
        }
    }

    private override init() {}

    func connect() {
        self.disconnect()

        let sessionHandler = MCSessionAdapter()
        if let session = self.mcSession {
            sessionHandler.setSession(session)
        }
        sessionHandler.delegate = self.delegate
        self.sessionHandler = sessionHandler
        guard let peerId = self.peerId else {
            return
        }
        let advertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: peerServiceType)
        advertiser.delegate = self
        self.advertiser = advertiser
        advertiser.startAdvertisingPeer()
    }

    func disconnect() {
        self.advertiser?.stopAdvertisingPeer()
        self.mcSession?.disconnect()
        self.sessionHandler = nil
        self.mcSession?.disconnect()
        self.delegate?.connectionClosed()
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Swift.Error) {
        self.delegate?.peerConnectionError(error)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Before invitation handler - \(mcSession?.connectedPeers)")
        //invitationHandler(true, self.mcSession)
        print("After invitation handler - \(mcSession?.connectedPeers)")
        self.delegate?.invitationReceived(from: peerID,
                                          context: context,
                                          invitationHandler: invitationHandler)
    }

    private func initialize(displayName: String?) {
        guard let name = displayName else {
            return
        }
        let peerId = MCPeerID(displayName: name)
        self.peerId = peerId
        let session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        self.mcSession = session
    }

}

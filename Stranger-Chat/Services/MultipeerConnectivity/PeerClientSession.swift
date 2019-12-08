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

    static private var instance: PeerClientSession?
    let mcSession: MCSession
    private let advertiser: MCNearbyServiceAdvertiser
    private let peerId: MCPeerID
    private let sessionHandler: MCSessionAdapter
    weak var delegate: PeerSessionDelegate? {
        didSet {
            sessionHandler.delegate = delegate
        }
    }

    override convenience private init() {
        self.init(name: "iPhone")
    }

    private init(name: String) {
        self.peerId = MCPeerID(displayName: name)
        self.mcSession = MCSession(peer: self.peerId, securityIdentity: nil, encryptionPreference: .required)
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.peerId, discoveryInfo: nil, serviceType: peerServiceType)
        self.sessionHandler = MCSessionAdapter()
        self.sessionHandler.setSession(self.mcSession)
        super.init()
        self.advertiser.delegate = self
    }

    class func getInstance(name: String = "iPhone") -> PeerClientSession {
        if let instance = instance {
            return instance
        }
        let newInstance = PeerClientSession(name: name)
        instance = newInstance
        return newInstance
    }

    func connect() {
        self.disconnect()
        advertiser.startAdvertisingPeer()
    }

    func disconnect() {
        self.advertiser.stopAdvertisingPeer()
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
        self.delegate?.invitationReceived(from: peerID,
                                          context: context,
                                          invitationHandler: invitationHandler)
    }

}

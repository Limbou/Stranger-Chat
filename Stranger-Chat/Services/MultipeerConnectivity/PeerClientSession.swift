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
    var mcSession: MCSession
    private var advertiser: MCNearbyServiceAdvertiser
    private var peerId: MCPeerID
    private let sessionHandler: MCSessionAdapter
    private let displayName: String
    weak var delegate: PeerSessionDelegate? {
        didSet {
            sessionHandler.delegate = delegate
        }
    }

    override convenience private init() {
        self.init(name: "iPhone")
    }

    private init(name: String) {
        self.displayName = name
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
        disconnect()
        advertiser.startAdvertisingPeer()
    }

    func disconnect() {
        advertiser.stopAdvertisingPeer()
        mcSession.disconnect()
        delegate?.connectionClosed()
    }

    func reset() {
        disconnect()
        peerId = MCPeerID(displayName: displayName)
        mcSession = MCSession(peer: self.peerId, securityIdentity: nil, encryptionPreference: .required)
        advertiser = MCNearbyServiceAdvertiser(peer: self.peerId, discoveryInfo: nil, serviceType: peerServiceType)
        sessionHandler.setSession(self.mcSession)
        advertiser.delegate = self
    }

    func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Swift.Error) {
        delegate?.peerConnectionError(error)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        delegate?.invitationReceived(from: peerID,
                                          context: context,
                                          invitationHandler: invitationHandler)
    }

}

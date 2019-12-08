//
//  PeerHostSession.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 16/04/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Foundation
import MultipeerConnectivity

final class PeerHostSession: NSObject, PeerConnection, MCNearbyServiceBrowserDelegate {

    static private var instance: PeerHostSession?
    let mcSession: MCSession
    let browser: MCNearbyServiceBrowser
    private let peerId: MCPeerID
    private let timeout: TimeInterval = 15.0
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
        self.browser = MCNearbyServiceBrowser(peer: self.peerId, serviceType: peerServiceType)
        self.sessionHandler = MCSessionAdapter()
        self.sessionHandler.setSession(self.mcSession)
        super.init()
        self.browser.delegate = self
    }

    class func getInstance(name: String = "iPhone") -> PeerHostSession {
        if let instance = instance {
            return instance
        }
        let newInstance = PeerHostSession(name: name)
        instance = newInstance
        return newInstance
    }

    func connect() {
        self.disconnect()
        browser.startBrowsingForPeers()
        self.delegate?.connectionReady()
    }

    func disconnect() {
        self.browser.stopBrowsingForPeers()
        self.delegate?.connectionClosed()
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        self.delegate?.peerDiscovered(peerID: peerID)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        self.delegate?.peerLost(peerID: peerID)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        self.delegate?.peerConnectionError(error)
    }

}

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
    var mcSession: MCSession
    private var browser: MCNearbyServiceBrowser
    private var peerId: MCPeerID
    private let sessionHandler: MCSessionAdapter
    var displayName: String {
        didSet {
            reset()
        }
    }
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
        disconnect()
        browser.startBrowsingForPeers()
        delegate?.connectionReady()
    }

    func disconnect() {
        browser.stopBrowsingForPeers()
        delegate?.connectionClosed()
    }

    func invite(peer: MCPeerID, withContext context: Data?, timeout: TimeInterval = 15) {
        browser.invitePeer(peer, to: mcSession, withContext: context, timeout: timeout)
    }

    func reset() {
        disconnect()
        mcSession.disconnect()
        peerId = MCPeerID(displayName: displayName)
        mcSession = MCSession(peer: self.peerId, securityIdentity: nil, encryptionPreference: .required)
        browser = MCNearbyServiceBrowser(peer: self.peerId, serviceType: peerServiceType)
        sessionHandler.setSession(self.mcSession)
        browser.delegate = self
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        delegate?.peerDiscovered(peerID: peerID, discoveryInfo: info)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.peerLost(peerID: peerID)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.peerConnectionError(error)
    }

}

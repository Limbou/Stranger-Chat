//
//  PeerHostSession.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 16/04/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class PeerHostSession:NSObject,PeerConnection,MCNearbyServiceBrowserDelegate {

    let mcSession:MCSession
    let peerId:MCPeerID
    var browser:MCNearbyServiceBrowser?
    let timeout:TimeInterval = 30.0
    let sessionHandler:MCSessionAdapter
    unowned let delegate:PeerSessionDelegate

    required init(displayName: String, delegate: PeerSessionDelegate) {
        let peerId = MCPeerID(displayName: displayName)
        self.peerId = peerId
        self.delegate = delegate
        self.mcSession = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        let sessionHandler = MCSessionAdapter()
        sessionHandler.setSession(self.mcSession)
        sessionHandler.delegate = delegate
        self.sessionHandler = sessionHandler
        super.init()
    }

    func connect() {
        self.disconnect()
        let browser = MCNearbyServiceBrowser(peer: self.peerId, serviceType: peerServiceType)
        self.browser = browser
        browser.delegate = self
        browser.startBrowsingForPeers()
        self.delegate.connectionReady()
    }

    func disconnect() {
        self.browser?.stopBrowsingForPeers()
        self.browser = nil
        self.delegate.connectionClosed()
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print(info)
        self.delegate.peerDiscovered(peerID: peerID)
        browser.invitePeer(peerID, to: self.mcSession, withContext: nil, timeout: self.timeout)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        self.delegate.peerLost(peerID: peerID)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        self.delegate.peerConnectionError(error)
    }

}

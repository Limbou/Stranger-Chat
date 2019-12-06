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

    static let shared = PeerHostSession()
    var mcSession: MCSession?
    private var peerId: MCPeerID?
    var browser: MCNearbyServiceBrowser?
    let timeout: TimeInterval = 15.0
    private var sessionHandler: MCSessionAdapter?
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
        guard let peerId = self.peerId else {
            return
        }
        let browser = MCNearbyServiceBrowser(peer: peerId, serviceType: peerServiceType)
        self.browser = browser
        browser.delegate = self
        browser.startBrowsingForPeers()
        self.delegate?.connectionReady()
    }

    func disconnect() {
        self.browser?.stopBrowsingForPeers()
        self.browser = nil
        self.delegate?.connectionClosed()
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        print(info ?? [])
        self.delegate?.peerDiscovered(peerID: peerID)
        if let session = self.mcSession {
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: self.timeout)
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        self.delegate?.peerLost(peerID: peerID)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        self.delegate?.peerConnectionError(error)
    }

    private func initialize(displayName: String?) {
        guard let displayName = displayName else {
            return
        }
        let peerId = MCPeerID(displayName: displayName)
        self.peerId = peerId
        self.mcSession = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        let sessionHandler = MCSessionAdapter()
        if let session = self.mcSession {
            sessionHandler.setSession(session)

        }
        self.sessionHandler = sessionHandler
    }

}

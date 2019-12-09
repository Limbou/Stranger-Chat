//
//  StrangersBrowserWorker.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation
import RxSwift
import MultipeerConnectivity

enum ConnectionState {
    case connecting
    case connected
    case disconnected
}

protocol StrangersBrowserWorker: AnyObject {
    func startBrowsing() -> Observable<[MCPeerID]>
    func stopBrowsing()
    func sendInvitationTo(peerIndex: Int) -> Observable<ConnectionState>
}

final class StrangersBrowserWorkerImpl: StrangersBrowserWorker {

    private let currentUserRepository: CurrentUserRepository
    private let session: PeerHostSession
    private var discoveredPeers: [MCPeerID] = []
    private let discovered = PublishSubject<[MCPeerID]>()
    private let connectionState = PublishSubject<ConnectionState>()

    init(currentUserRepository: CurrentUserRepository, session: PeerHostSession = PeerHostSession.getInstance(name: "Abcd")) {
        self.currentUserRepository = currentUserRepository
        self.session = session
    }

    func startBrowsing() -> Observable<[MCPeerID]> {
//        guard let userName = currentUserRepository.currentUser()?.name else {
//            print("No user")
//            return Observable.empty()
//        }
        session.delegate = self
        session.connect()
        return discovered
    }

    func stopBrowsing() {
        session.disconnect()
    }

    func sendInvitationTo(peerIndex: Int) -> Observable<ConnectionState> {
        guard let peer = discoveredPeers[safe: peerIndex] else {
            print("No peer with such index")
            return Observable.empty()
        }
        session.browser.invitePeer(peer, to: session.mcSession, withContext: nil, timeout: 15)
        return connectionState
    }

}

extension StrangersBrowserWorkerImpl: PeerSessionDelegate {

    func peerDiscovered(peerID: MCPeerID) {
        discoveredPeers.append(peerID)
        discovered.onNext(discoveredPeers)
    }

    func peerLost(peerID: MCPeerID) {
        print("Lost peer: \(peerID.displayName)")
        guard let indexOfPeer = discoveredPeers.firstIndex(of: peerID) else {
            return
        }
        discoveredPeers.remove(at: indexOfPeer)
        discovered.onNext(discoveredPeers)
    }

    func peerConnecting(peerID: MCPeerID) {
        print("Connecting...")
        connectionState.onNext(.connecting)
    }

    func peerConnected(peerID: MCPeerID) {
        print("CONNECTED!")
        connectionState.onNext(.connected)
    }

    func peerDisconnected(peerID: MCPeerID) {
        print("#$&#$& DISCONNECTED")
        connectionState.onNext(.disconnected)
    }

}

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
    func resetConnection()
    func startBrowsing() -> Observable<[DiscoverableUser]>
    func stopBrowsing()
    func sendInvitationTo(user: DiscoverableUser, context: Data?) -> Observable<ConnectionState>
    func isOnline() -> Bool
}

final class StrangersBrowserWorkerImpl: StrangersBrowserWorker {

    private let currentUserRepository: CurrentUserRepository
    private let session: PeerHostSession
    private var discoveredPeers: [DiscoverableUser] = []
    private let discovered = PublishSubject<[DiscoverableUser]>()
    private let connectionState = PublishSubject<ConnectionState>()

    init(currentUserRepository: CurrentUserRepository, session: PeerHostSession) {
        self.currentUserRepository = currentUserRepository
        self.session = session
        setupDisplayName()
    }

    func resetConnection() {
        session.reset()
    }

    func startBrowsing() -> Observable<[DiscoverableUser]> {
        guard currentUserRepository.currentUser() != nil else {
            print("No user")
            return Observable.empty()
        }
        discoveredPeers = []
        session.delegate = self
        session.connect()
        return discovered
    }

    func stopBrowsing() {
        session.disconnect()
    }

    func sendInvitationTo(user: DiscoverableUser, context: Data?) -> Observable<ConnectionState> {
        guard discoveredPeers.contains(where: { $0.peer == user.peer }) else {
            print("User already unavailable")
            return Observable.empty()
        }
        session.invite(peer: user.peer, withContext: context)
        return connectionState
    }

    private func setupDisplayName() {
        guard let userName = currentUserRepository.currentUser()?.name else {
            print("No user")
            return
        }
        session.displayName = userName
    }

    func isOnline() -> Bool {
        return currentUserRepository.isOnline()
    }

}

extension StrangersBrowserWorkerImpl: PeerSessionDelegate {

    func peerDiscovered(peerID: MCPeerID, discoveryInfo: [String: String]?) {
        let user = DiscoverableUser(peer: peerID, discoveryInfo: discoveryInfo)
        discoveredPeers.append(user)
        discovered.onNext(discoveredPeers)
    }

    func peerLost(peerID: MCPeerID) {
        print("Lost peer: \(peerID.displayName)")
        guard let indexOfPeer = discoveredPeers.firstIndex(where: { $0.peer == peerID }) else {
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
        print("#$&#$& DISCONNECTED: \(peerID)")
        DispatchQueue.main.async {
            self.connectionState.onNext(.disconnected)
        }
    }

}

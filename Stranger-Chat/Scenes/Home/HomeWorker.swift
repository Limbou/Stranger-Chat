//
//  HomeWorker.swift
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

protocol HomeWorker: AnyObject {
    func startAdvertising() -> Observable<SessionInvitation>
    func stopAdvertising()
    func declineInvitation()
    func acceptInvitation() -> Observable<ConnectionState>
}

typealias InvitationHandler = (Bool, MCSession?) -> Void

final class HomeWorkerImpl: HomeWorker {

    private let currentUserRepository: CurrentUserRepository
    private let session: PeerClientSession
    private let invitations = PublishSubject<SessionInvitation>()
    private var latestInvitationHandler: InvitationHandler?
    private let connectionState = PublishSubject<ConnectionState>()

    init(currentUserRepository: CurrentUserRepository, session: PeerClientSession) {
        self.currentUserRepository = currentUserRepository
        self.session = session
        setupSession()
    }

    func startAdvertising() -> Observable<SessionInvitation> {
        guard currentUserRepository.currentUser() != nil else {
            print("No user")
            return Observable.empty()
        }
        session.delegate = self
        session.connect()
        return invitations
    }

    func stopAdvertising() {
        session.stopAdvertising()
    }

    func declineInvitation() {
        guard let latestInvitationHandler = latestInvitationHandler else {
            print("No invitation handler")
            return
        }
        latestInvitationHandler(false, nil)
    }

    func acceptInvitation() -> Observable<ConnectionState> {
        guard let latestInvitationHandler = latestInvitationHandler else {
            print("No invitation handler")
            return Observable.empty()
        }
        latestInvitationHandler(true, session.mcSession)
        return connectionState
    }

    private func setupSession() {
        guard let userName = currentUserRepository.currentUser()?.name else {
            print("No user")
            return
        }
        let discoveryInfo = [PeerConstants.isOnlineKey: "\(currentUserRepository.isOnline())"]
        session.set(displayName: userName, discoveryInfo: discoveryInfo)
    }

}

extension HomeWorkerImpl: PeerSessionDelegate {

    func peerConnectionError(_ error: Error) {

    }

    func invitationReceived(from peerID: MCPeerID,
                            context: Data?,
                            invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        latestInvitationHandler = invitationHandler
        let invitation = SessionInvitation(peerId: peerID, context: context)
        invitations.onNext(invitation)
    }

    func peerConnecting(peerID: MCPeerID) {
        connectionState.onNext(.connecting)
    }

    func peerConnected(peerID: MCPeerID) {
        connectionState.onNext(.connected)
    }

    func peerDisconnected(peerID: MCPeerID) {
        connectionState.onNext(.disconnected)
    }

}

struct SessionInvitation {
    let peerId: MCPeerID
    let context: Data?
}

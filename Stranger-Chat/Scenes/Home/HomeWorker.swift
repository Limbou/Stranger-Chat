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
    func acceptInvitation()
}

typealias InvitationHandler = (Bool, MCSession?) -> Void

final class HomeWorkerImpl: HomeWorker {

    private let currentUserRepository: CurrentUserRepository
    private let session: PeerClientSession
    private let invitations = PublishSubject<SessionInvitation>()
    private var latestInvitationHandler: InvitationHandler?

    init(currentUserRepository: CurrentUserRepository, session: PeerClientSession) {
        self.currentUserRepository = currentUserRepository
        self.session = session
    }

    func startAdvertising() -> Observable<SessionInvitation> {
//        guard let userName = currentUserRepository.currentUser()?.name else {
//            print("No user")
//            return
//        }
        session.displayName = "Siemka"
        session.delegate = self
        session.connect()
        return invitations
    }

    func stopAdvertising() {
        session.disconnect()
    }

    func acceptInvitation() {
        guard let session = session.mcSession,
            let latestInvitationHandler = latestInvitationHandler else {
            print("No session")
            return
        }
        latestInvitationHandler(true, session)
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

}

struct SessionInvitation {
    let peerId: MCPeerID
    let context: Data?
}

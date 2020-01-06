//
//  StrangersBrowserPresenter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation

protocol StrangersBrowserDisplayable: AnyObject {
    func display(users: [DisplayableFoundUser])
    func presentInvitationSentAlert(user: String)
    func presentInvitationDeclinedAlert()
    func hideInvitationSentAlert()
}

protocol StrangersBrowserPresenter: AnyObject {
    var viewController: StrangersBrowserDisplayable? { get set }
    func display(users: [DiscoverableUser])
    func presentInvitationSentAlert(user: String)
    func presentInvitationDeclinedAlert()
    func hideInvitationSentAlert()
}

struct DisplayableFoundUser {
    let name: String
    let isOnline: Bool
}

final class StrangersBrowserPresenterImpl: StrangersBrowserPresenter {

    weak var viewController: StrangersBrowserDisplayable?

    func display(users: [DiscoverableUser]) {
        let displayableUsers = users.map { DisplayableFoundUser(name: $0.peer.displayName,
                                                                isOnline: $0.discoveryInfo?[PeerConstants.isOnlineKey]?.bool ?? false) }
        viewController?.display(users: displayableUsers)
    }

    func presentInvitationSentAlert(user: String) {
        viewController?.presentInvitationSentAlert(user: user)
    }

    func presentInvitationDeclinedAlert() {
        viewController?.presentInvitationDeclinedAlert()
    }

    func hideInvitationSentAlert() {
        viewController?.hideInvitationSentAlert()
    }

}

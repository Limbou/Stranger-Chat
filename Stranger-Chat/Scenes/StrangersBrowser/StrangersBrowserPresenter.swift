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
    func display(users: [String])
    func presentInvitationSentAlert()
}

protocol StrangersBrowserPresenter: AnyObject {
    var viewController: StrangersBrowserDisplayable? { get set }
    func display(users: [String])
    func presentInvitationSentAlert()
}

final class StrangersBrowserPresenterImpl: StrangersBrowserPresenter {

    weak var viewController: StrangersBrowserDisplayable?

    func display(users: [String]) {
        viewController?.display(users: users)
    }

    func presentInvitationSentAlert() {
        viewController?.presentInvitationSentAlert()
    }

}

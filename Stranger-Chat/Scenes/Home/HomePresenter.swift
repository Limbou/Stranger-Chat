//
//  HomePresenter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation

protocol HomeDisplayable: Displayable {
    func setAdvertisingButton(advertising: Bool)
    func presentInvitation(from sender: String, additionalInfo: String?)
}

protocol HomePresenter: AnyObject {
    var viewController: HomeDisplayable? { get set }
    func setAdvertisingButton(advertising: Bool)
    func presentInvitation(from sender: String, additionalInfo: String?)
    func presentLoading()
    func hideLoading()
}

final class HomePresenterImpl: HomePresenter {

    weak var viewController: HomeDisplayable?

    func setAdvertisingButton(advertising: Bool) {
        viewController?.setAdvertisingButton(advertising: advertising)
    }

    func presentInvitation(from sender: String, additionalInfo: String?) {
        viewController?.presentInvitation(from: sender, additionalInfo: additionalInfo)
    }

    func presentLoading() {
        viewController?.presentLoading()
    }

    func hideLoading() {
        viewController?.hideLoading()
    }

}

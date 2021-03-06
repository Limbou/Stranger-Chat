//
//  LoginPresenter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

private enum Constants {
    static let generalError = "login.generalError.title"
    static let wrongCredentialsErrorTitle = "login.error.title"
    static let wrongCredentialsErrorMessage = "login.error.message"
    static let connectionErrorTitle = "connection.error.title"
    static let connectionErrorMessage = "connection.error.message"
    static let emailUnverifiedError = "error.emailUnverified"
}

protocol LoginDisplayable: Displayable {
    func showError(title: String, message: String)
}

protocol LoginPresenter: AnyObject {
    var viewController: LoginDisplayable? { get set }
    func showWrongCredentialsError()
    func showConnectionError()
    func showEmailUnverifiedError()
    func presentLoading()
    func hideLoading()
}

final class LoginPresenterImpl: LoginPresenter {

    weak var viewController: LoginDisplayable?

    func showWrongCredentialsError() {
        viewController?.showError(title: Constants.wrongCredentialsErrorTitle.localized(),
                                  message: Constants.wrongCredentialsErrorMessage.localized())
    }

    func showConnectionError() {
        viewController?.showError(title: Constants.connectionErrorTitle.localized(),
                                  message: Constants.connectionErrorMessage.localized())
    }

    func showEmailUnverifiedError() {
        viewController?.showError(title: Constants.generalError.localized(),
                                  message: Constants.emailUnverifiedError.localized())
    }

    func presentLoading() {
        viewController?.presentLoading()
    }

    func hideLoading() {
        viewController?.hideLoading()
    }

}

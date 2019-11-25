//
//  LoginPresenter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol LoginDisplayable: AnyObject {
    func showWrongCredentialsError()
}

protocol LoginPresenter: AnyObject {
    var viewController: LoginDisplayable? { get set }
    func showWrongCredentialsError()
}

final class LoginPresenterImpl: LoginPresenter {

    weak var viewController: LoginDisplayable?

    func showWrongCredentialsError() {
        viewController?.showWrongCredentialsError()
    }

}

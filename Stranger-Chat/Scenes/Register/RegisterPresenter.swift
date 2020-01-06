//
//  RegisterPresenter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import UIKit

protocol RegisterDisplayable: Displayable {
    func show(error: String)
}

protocol RegisterPresenter: AnyObject {
    var viewController: RegisterDisplayable? { get set }
    func show(error: Error)
    func presentLoading()
    func hideLoading()
}

final class RegisterPresenterImpl: RegisterPresenter {

    weak var viewController: RegisterDisplayable?

    func show(error: Error) {
        viewController?.show(error: error.localizedDescription)
    }

    func presentLoading() {
        viewController?.presentLoading()
    }

    func hideLoading() {
        viewController?.hideLoading()
    }
    
}

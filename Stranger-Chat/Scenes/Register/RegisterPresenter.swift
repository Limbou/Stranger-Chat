//
//  RegisterPresenter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation

protocol RegisterDisplayable: AnyObject {

}

protocol RegisterPresenter: AnyObject {
    var viewController: RegisterDisplayable? { get set }
}

final class RegisterPresenterImpl: RegisterPresenter {

    weak var viewController: RegisterDisplayable?

}

//
//  RegisterPresenter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol RegisterDisplayable: AnyObject {

}

protocol RegisterPresenter: AnyObject {
    var viewController: RegisterDisplayable? { get set }
}

final class RegisterPresenterImpl: RegisterPresenter {

    weak var viewController: RegisterDisplayable?

}

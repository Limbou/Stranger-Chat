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

protocol RegisterPresentable: AnyObject {
    var viewController: RegisterDisplayable? { get set }
}

final class RegisterPresenter: RegisterPresentable {

    weak var viewController: RegisterDisplayable?

}

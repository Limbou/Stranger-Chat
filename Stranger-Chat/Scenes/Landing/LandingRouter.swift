//
//  LandingRouter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import UIKit

struct LandingRouter {

    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

}

extension LandingRouter: LandingRoutable {

    func showLoginScene() {
        let loginViewController = UIViewController() //LoginViewController in the future
        push(viewController: loginViewController)
    }

    func showRegisterScene() {
        let registerViewController = UIViewController()
        push(viewController: registerViewController) //RegisterViewController in the future
    }

}

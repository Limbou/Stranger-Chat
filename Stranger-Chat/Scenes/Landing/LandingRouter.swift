//
//  LandingRouter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol LandingRouter: Router {
    func showLoginScene()
    func showRegisterScene()
    func showOfflineModeLoginScene()
}

final class LandingRouterImpl: LandingRouter {

    weak var viewController: UIViewController?

    func showLoginScene() {
        let loginViewController = Provider.get.instanceOf(LoginViewController.self)
        push(viewController: loginViewController)
    }

    func showRegisterScene() {
        let registerViewController = Provider.get.instanceOf(RegisterViewController.self)
        push(viewController: registerViewController)
    }

    func showOfflineModeLoginScene() {
        let registerViewController = Provider.get.instanceOf(OfflineModeLoginViewController.self)
        push(viewController: registerViewController)
    }

}

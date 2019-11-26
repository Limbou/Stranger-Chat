//
//  RegisterRouter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import UIKit

protocol RegisterRouter: Router {
    func goToHomeScreen()
}

final class RegisterRouterImpl: RegisterRouter {

    weak var viewController: UIViewController?

    func goToHomeScreen() {
        let mainTab = Provider.get.instanceOf(MainTabBarController.self)
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController = mainTab
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)

    }

}

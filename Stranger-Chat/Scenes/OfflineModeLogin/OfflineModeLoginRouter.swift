//
//  RegisterRouter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol OfflineModeLoginRouter: Router {
    func showHomeScreen()
}

final class OfflineModeLoginRouterImpl: OfflineModeLoginRouter {

    weak var viewController: UIViewController?

    func showHomeScreen() {
        let mainTab = Provider.get.instanceOf(MainTabBarController.self)
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController = mainTab
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }

}

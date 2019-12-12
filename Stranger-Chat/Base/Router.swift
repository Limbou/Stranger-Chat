//
//  Router.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol Router: AnyObject {

    var viewController: UIViewController? { get set }

    func push(viewController: UIViewController, animated: Bool)
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss()

}

extension Router {

    func push(viewController: UIViewController, animated: Bool = true) {
        guard let navigationController = self.viewController?.navigationController else {
            return
        }
        navigationController.pushViewController(viewController, animated: animated)
    }

    func present(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let currentViewController = self.viewController else {
            return
        }
        currentViewController.present(viewController, animated: animated, completion: completion)
    }

    func dismiss() {
        guard let navController = viewController?.navigationController else {
            viewController?.dismiss(animated: true)
            return
        }
        guard navController.viewControllers.count > 1 else {
            return navController.dismiss(animated: true)
        }
        navController.popViewController(animated: true)
    }

}

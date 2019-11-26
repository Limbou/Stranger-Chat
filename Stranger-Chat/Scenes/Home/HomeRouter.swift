//
//  HomeRouter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import UIKit

protocol HomeRouter: Router {
    func goToStrangersBrowser()
}

final class HomeRouterImpl: HomeRouter {

    weak var viewController: UIViewController?

    func goToStrangersBrowser() {
        let viewController = Provider.get.instanceOf(StrangersBrowserViewController.self)
        push(viewController: viewController)
    }

}

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
    func goToChat(online: Bool)
}

final class HomeRouterImpl: HomeRouter {

    weak var viewController: UIViewController?

    func goToStrangersBrowser() {
        let browserViewController = Provider.get.instanceOf(StrangersBrowserViewController.self)
        push(viewController: browserViewController)
    }

    func goToChat(online: Bool) {
        let chatViewController = Provider.get.instanceOf(ChatViewController.self, argument: PeerClientSession.getInstance() as PeerConnection)
        let navigationController = UINavigationController(rootViewController: chatViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(viewController: navigationController)
    }

}

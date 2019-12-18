//
//  StrangersBrowserRouter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import UIKit

protocol StrangersBrowserRouter: Router {
    func goToChat(online: Bool)
}

final class StrangersBrowserRouterImpl: StrangersBrowserRouter {

    weak var viewController: UIViewController?

    func goToChat(online: Bool) {
        let chatViewController = Provider.get.instanceOf(ChatViewController.self, arguments: PeerHostSession.getInstance() as PeerConnection, online)
        let navigationController = UINavigationController(rootViewController: chatViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(viewController: navigationController)
    }

}

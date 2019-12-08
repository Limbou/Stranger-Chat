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
    func goToChat()
}

final class StrangersBrowserRouterImpl: StrangersBrowserRouter {

    weak var viewController: UIViewController?

    func goToChat() {
        let chatViewController = Provider.get.instanceOf(ChatViewController.self, argument: PeerHostSession.getInstance() as PeerConnection)
        chatViewController.modalPresentationStyle = .fullScreen
        present(viewController: chatViewController)
    }

}

//
//  ChatRouter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 08/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import UIKit

protocol ChatRouter: Router {
    func dismissView()
    func navigateToImageView(image: UIImage)
}

final class ChatRouterImpl: ChatRouter {

    weak var viewController: UIViewController?

    func dismissView() {
        viewController?.navigationController?.dismiss(animated: true, completion: nil)
    }

    func navigateToImageView(image: UIImage) {
        let photoViewController = Provider.get.instanceOf(PhotoViewController.self, argument: image)
        viewController?.navigationController?.pushViewController(photoViewController, animated: true)
    }

}

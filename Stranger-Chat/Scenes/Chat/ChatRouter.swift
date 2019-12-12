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

protocol ChatRouter: AnyObject {
    var viewController: UIViewController? { get set }
    func dismissView()
}

final class ChatRouterImpl: ChatRouter {

    weak var viewController: UIViewController?

    func dismissView() {
        viewController?.navigationController?.dismiss(animated: true, completion: nil)
    }

}

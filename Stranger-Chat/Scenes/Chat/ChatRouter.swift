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
}

final class ChatRouterImpl: ChatRouter {

    weak var viewController: UIViewController?

}

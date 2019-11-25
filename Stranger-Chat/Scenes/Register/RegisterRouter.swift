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

protocol RegisterRouter: AnyObject {
    var viewController: UIViewController? { get set }
}

final class RegisterRouterImpl: RegisterRouter {

    weak var viewController: UIViewController?

}

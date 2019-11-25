//
//  LoginRouter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol LoginRouter: AnyObject {
    var viewController: UIViewController? { get set }
    func goToMainScreen()
}

final class LoginRouterImpl: LoginRouter {

    weak var viewController: UIViewController?

    func goToMainScreen() {
        
    }

}

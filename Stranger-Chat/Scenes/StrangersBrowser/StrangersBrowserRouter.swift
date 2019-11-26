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
    
}

final class StrangersBrowserRouterImpl: StrangersBrowserRouter {

    weak var viewController: UIViewController?

}

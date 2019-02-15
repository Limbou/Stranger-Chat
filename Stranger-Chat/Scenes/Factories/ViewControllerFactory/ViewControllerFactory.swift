//
//  ViewControllerFactory.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import Foundation

final class ViewControllerFactory {

    func getLandingViewController() -> LandingViewController {
        let router = LandingRouter()
        let interactor = LandingInteractorImpl(router: router)
        let controller = LandingViewController(interactor: interactor)
        router.viewController = controller
        return controller
    }

}

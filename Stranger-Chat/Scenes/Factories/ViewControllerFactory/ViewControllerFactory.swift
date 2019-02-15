//
//  ViewControllerFactory.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import Foundation

struct ViewControllerFactory {

    private let routerFactory = RouterFactory()
    private let interactorFactory = InteractorFactory()
    private let presenterFactory = PresenterFactory()

    func getLandingViewController() -> LandingViewController {
        let router = routerFactory.getLandingRouter()
        let interactor = interactorFactory.getLandingInteractor(router: router)
        let controller = LandingViewController(interactor: interactor)
        router.viewController = controller
        return controller
    }

    func getRegisterViewController() -> RegisterViewController {
        let router = routerFactory.getRegisterRouter()
        let presenter = presenterFactory.getRegisterPresenter()
        let interactor = interactorFactory.getRegisterInteractor(presenter: presenter, router: router)
        let controller = RegisterViewController(interactor: interactor)
        router.viewController = controller
        presenter.viewController = controller
        return controller
    }

}

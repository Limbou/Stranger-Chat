//
//  ViewControllerFactory.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import Foundation

final class ViewControllerFactory {

    static let get = ViewControllerFactory()
    private let routerFactory: RouterFactory
    private let interactorFactory: InteractorFactory
    private let presenterFactory: PresenterFactory

    private init() {
        routerFactory = RouterFactory()
        interactorFactory = InteractorFactory()
        presenterFactory = PresenterFactory()
    }

    func landingViewController() -> LandingViewController {
        let router = routerFactory.getLandingRouter()
        let interactor = interactorFactory.getLandingInteractor(router: router)
        let controller = LandingViewController(interactor: interactor)
        router.viewController = controller
        return controller
    }

    func registerViewController() -> OfflineModeLoginViewController {
        let router = routerFactory.getRegisterRouter()
        let presenter = presenterFactory.getRegisterPresenter()
        let interactor = interactorFactory.getOfflineModeLoginInteractor(presenter: presenter, router: router)
        let controller = OfflineModeLoginViewController(interactor: interactor)
        router.viewController = controller
        presenter.viewController = controller
        return controller
    }

}

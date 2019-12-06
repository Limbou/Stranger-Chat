//
//  ViewControllerAssembly.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 21/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

final class ScreenAssembly: Assembly {

    func assemble(container: Container) {

        container.autoregister(LandingViewController.self, initializer: LandingViewController.init(interactor:))
        container.autoregister(LandingInteractor.self, initializer: LandingInteractorImpl.init(router:))
        container.autoregister(LandingRouter.self, initializer: LandingRouterImpl.init).initCompleted { (resolver, router) in
            router.viewController = resolver ~> LandingViewController.self
        }

        container.autoregister(LoginViewController.self, initializer: LoginViewController.init(interactor:))
        container.autoregister(LoginInteractor.self, initializer: LoginInteractorImpl.init(presenter:router:worker:))
        container.autoregister(LoginPresenter.self, initializer: LoginPresenterImpl.init).initCompleted { (resolver, presenter) in
            presenter.viewController = resolver ~> LoginViewController.self
        }
        container.autoregister(LoginWorker.self, initializer: LoginWorkerImpl.init(usersRepository:))
        container.autoregister(LoginRouter.self, initializer: LoginRouterImpl.init).initCompleted { (resolver, router) in
            router.viewController = resolver ~> LoginViewController.self
        }

        container.autoregister(RegisterViewController.self, initializer: RegisterViewController.init(interactor:))
        container.autoregister(RegisterInteractor.self, initializer: RegisterInteractorImpl.init(presenter:router:worker:))
        container.autoregister(RegisterPresenter.self, initializer: RegisterPresenterImpl.init).initCompleted { (resolver, presenter) in
            presenter.viewController = resolver ~> RegisterViewController.self
        }
        container.autoregister(RegisterWorker.self, initializer: RegisterWorkerImpl.init(usersRepository:))
        container.autoregister(RegisterRouter.self, initializer: RegisterRouterImpl.init).initCompleted { (resolver, router) in
            router.viewController = resolver ~> RegisterViewController.self
        }

        container.autoregister(OfflineModeLoginViewController.self, initializer: OfflineModeLoginViewController.init(interactor:))
        container.autoregister(OfflineModeLoginInteractor.self, initializer: OfflineModeLoginInteractorImpl.init(presenter:router:worker:))
        container.autoregister(OfflineModeLoginPresenter.self, initializer: OfflineModeLoginPresenterImpl.init).initCompleted { (resolver, presenter) in
            presenter.viewController = resolver ~> OfflineModeLoginViewController.self
        }
        container.autoregister(OfflineModeLoginWorker.self, initializer: OfflineModeLoginWorkerImpl.init)
        container.autoregister(OfflineModeLoginRouter.self, initializer: OfflineModeLoginRouterImpl.init).initCompleted { (resolver, router) in
            router.viewController = resolver ~> OfflineModeLoginViewController.self
        }

        container.autoregister(MainTabBarController.self, initializer: MainTabBarController.init)

        container.autoregister(HomeViewController.self, initializer: HomeViewController.init(interactor:))
        container.autoregister(HomeInteractor.self, initializer: HomeInteractorImpl.init(presenter:router:worker:))
        container.autoregister(HomePresenter.self, initializer: HomePresenterImpl.init).initCompleted { (resolver, presenter) in
            presenter.viewController = resolver ~> HomeViewController.self
        }
        container.autoregister(HomeWorker.self, initializer: HomeWorkerImpl.init)
        container.autoregister(HomeRouter.self, initializer: HomeRouterImpl.init).initCompleted { (resolver, router) in
            router.viewController = resolver ~> HomeViewController.self
        }

        container.autoregister(StrangersBrowserViewController.self, initializer: StrangersBrowserViewController.init(interactor:))
        container.autoregister(StrangersBrowserInteractor.self, initializer: StrangersBrowserInteractorImpl.init(presenter:router:worker:))
        container.autoregister(StrangersBrowserPresenter.self, initializer: StrangersBrowserPresenterImpl.init).initCompleted { (resolver, presenter) in
            presenter.viewController = resolver ~> StrangersBrowserViewController.self
        }
        container.autoregister(StrangersBrowserWorker.self, initializer: StrangersBrowserWorkerImpl.init(currentUserRepository:session:))
        container.autoregister(StrangersBrowserRouter.self, initializer: StrangersBrowserRouterImpl.init).initCompleted { (resolver, router) in
            router.viewController = resolver ~> StrangersBrowserViewController.self
        }

    }

}

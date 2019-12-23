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
        assembleLanding(container)
        assembleLogin(container)
        assembleRegister(container)
        assembleOfflineModeLogin(container)
        assembleMainTabBar(container)
        assembleHome(container)
        assembleStrangerBrowser(container)
        assembleChat(container)
        assemblePhoto(container)
        assembleBrowsing(container)
    }

    private func assembleLanding(_ container: Container) {
        container.autoregister(LandingViewController.self, initializer: LandingViewController.init(interactor:))
        container.autoregister(LandingInteractor.self, initializer: LandingInteractorImpl.init(router:))
        container.autoregister(LandingRouter.self, initializer: LandingRouterImpl.init).initCompleted { (resolver, router) in
            router.viewController = resolver ~> LandingViewController.self
        }
    }

    private func assembleLogin(_ container: Container) {
        container.autoregister(LoginViewController.self, initializer: LoginViewController.init(interactor:))
        container.autoregister(LoginInteractor.self, initializer: LoginInteractorImpl.init(presenter:router:worker:))
        container.autoregister(LoginPresenter.self, initializer: LoginPresenterImpl.init).initCompleted { (resolver, presenter) in
            presenter.viewController = resolver ~> LoginViewController.self
        }
        container.autoregister(LoginWorker.self, initializer: LoginWorkerImpl.init(usersRepository:))
        container.autoregister(LoginRouter.self, initializer: LoginRouterImpl.init).initCompleted { (resolver, router) in
            router.viewController = resolver ~> LoginViewController.self
        }
    }

    private func assembleRegister(_ container: Container) {
        container.autoregister(RegisterViewController.self, initializer: RegisterViewController.init(interactor:))
        container.autoregister(RegisterInteractor.self, initializer: RegisterInteractorImpl.init(presenter:router:worker:))
        container.autoregister(RegisterPresenter.self, initializer: RegisterPresenterImpl.init).initCompleted { (resolver, presenter) in
            presenter.viewController = resolver ~> RegisterViewController.self
        }
        container.autoregister(RegisterWorker.self, initializer: RegisterWorkerImpl.init(usersRepository:firestoreUsersRepository:))
        container.autoregister(RegisterRouter.self, initializer: RegisterRouterImpl.init).initCompleted { (resolver, router) in
            router.viewController = resolver ~> RegisterViewController.self
        }
    }

    private func assembleOfflineModeLogin(_ container: Container) {
        container.autoregister(OfflineModeLoginViewController.self, initializer: OfflineModeLoginViewController.init(interactor:))
        container.autoregister(OfflineModeLoginInteractor.self, initializer: OfflineModeLoginInteractorImpl.init(presenter:router:worker:))
        container.autoregister(OfflineModeLoginPresenter.self, initializer: OfflineModeLoginPresenterImpl.init).initCompleted { (resolver, presenter) in
            presenter.viewController = resolver ~> OfflineModeLoginViewController.self
        }
        container.autoregister(OfflineModeLoginWorker.self, initializer: OfflineModeLoginWorkerImpl.init)
        container.autoregister(OfflineModeLoginRouter.self, initializer: OfflineModeLoginRouterImpl.init).initCompleted { (resolver, router) in
            router.viewController = resolver ~> OfflineModeLoginViewController.self
        }
    }

    private func assembleMainTabBar(_ container: Container) {
        container.autoregister(MainTabBarController.self, initializer: MainTabBarController.init)
    }

     private func assembleHome(_ container: Container) {
        container.autoregister(HomeViewController.self, initializer: HomeViewController.init(interactor:))
        container.autoregister(HomeInteractor.self, initializer: HomeInteractorImpl.init(presenter:router:worker:))
        container.autoregister(HomePresenter.self, initializer: HomePresenterImpl.init).initCompleted { (resolver, presenter) in
            presenter.viewController = resolver ~> HomeViewController.self
        }
        container.register(HomeWorker.self) { resolver in
            return HomeWorkerImpl(currentUserRepository: resolver.resolve(CurrentUserRepository.self)!, session: resolver ~> PeerClientSession.self)
        }
        container.autoregister(HomeRouter.self, initializer: HomeRouterImpl.init).initCompleted { (resolver, router) in
            router.viewController = resolver ~> HomeViewController.self
        }
    }

    private func assembleStrangerBrowser(_ container: Container) {
        container.autoregister(StrangersBrowserViewController.self, initializer: StrangersBrowserViewController.init(interactor:))
        container.autoregister(StrangersBrowserInteractor.self, initializer: StrangersBrowserInteractorImpl.init(presenter:router:worker:))
        container.autoregister(StrangersBrowserPresenter.self, initializer: StrangersBrowserPresenterImpl.init).initCompleted { (resolver, presenter) in
            presenter.viewController = resolver ~> StrangersBrowserViewController.self
        }
        container.register(StrangersBrowserWorker.self) { resolver in
            StrangersBrowserWorkerImpl(currentUserRepository: resolver.resolve(CurrentUserRepository.self)!, session: resolver ~> PeerHostSession.self)
        }
        container.autoregister(StrangersBrowserRouter.self, initializer: StrangersBrowserRouterImpl.init).initCompleted { (resolver, router) in
            router.viewController = resolver ~> StrangersBrowserViewController.self
        }
    }

    private func assembleChat(_ container: Container) {
        var peerConnectionArgument: PeerConnection!
        var isOnline: Bool!
        container.register(ChatViewController.self) { (resolver, peerConnection: PeerConnection, online: Bool) in
            peerConnectionArgument = peerConnection
            isOnline = online
            return ChatViewController(interactor: resolver.resolve(ChatInteractor.self, arguments: peerConnection, online)!,
                                      cellFactory: resolver ~> ChatCellFactory.self)
        }

        container.register(ChatInteractor.self) { (resolver, peerConnection: PeerConnection, online: Bool) in
            if online {
                return ChatOnlineInteractor(presenter: resolver ~> ChatPresenter.self,
                                            router: resolver.resolve(ChatRouter.self, argument: peerConnection)!,
                                            worker: resolver.resolve(ChatOnlineWorker.self, argument: peerConnection)!)
            }
            return ChatOfflineInteractor(presenter: resolver ~> ChatPresenter.self,
                                         router: resolver.resolve(ChatRouter.self, argument: peerConnection)!,
                                         worker: resolver.resolve(ChatOfflineWorker.self, argument: peerConnection)!)
        }
        container.autoregister(ChatPresenter.self, initializer: ChatPresenterImpl.init).initCompleted { (resolver, presenter) in
            presenter.viewController = resolver.resolve(ChatViewController.self, arguments: peerConnectionArgument!, isOnline!)
        }
        container.register(ChatOnlineWorker.self) { resolver, peerConnection in
            ChatOnlineWorkerImpl(peerConnection: peerConnection,
                                 chatRepository: resolver ~> FirestoreChatRepository.self,
                                 userRepository: resolver ~> FirebaseUsersRepository.self,
                                 firestoreUserRepository: resolver ~> FirestoreUsersRepository.self)
        }
        container.register(ChatOfflineWorker.self) { resolver, peerConnection in
            ChatOfflineWorkerImpl(peerConnection: peerConnection,
                                  fileManager: resolver ~> FileManager.self,
                                  localConversationRepository: resolver ~> LocalConversationRepository.self)
        }
        container.register(ChatRouter.self) { (resolver, peerConnection: PeerConnection) in
            return ChatRouterImpl()
        }.initCompleted { (resolver, router) in
            router.viewController = resolver.resolve(ChatViewController.self, arguments: peerConnectionArgument!, isOnline!)
        }
        container.autoregister(ChatCellFactory.self, initializer: ChatCellFactoryImpl.init)
    }

    private func assemblePhoto(_ container: Container) {
        container.autoregister(PhotoViewController.self, argument: UIImage.self, initializer: PhotoViewController.init(photo:))
    }

    private func assembleBrowsing(_ container: Container) {
        container.autoregister(BrowsingViewController.self, initializer: BrowsingViewController.init)
    }

}

//
//  LandingRouter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol LandingRouter: Router {
    var loginObserver: AnyObserver<Void> { get }
    var offlineModeObserver: AnyObserver<Void> { get }
}

final class LandingRouterImpl: LandingRouter {

    private let bag = DisposeBag()
    private let loginSubject = PublishSubject<Void>()
    var loginObserver: AnyObserver<Void> {
        return loginSubject.asObserver()
    }
    private let offlineModeSubject = PublishSubject<Void>()
    var offlineModeObserver: AnyObserver<Void> {
        return offlineModeSubject.asObserver()
    }
    weak var viewController: UIViewController?

    init() {
        setupBindings()
    }

    private func setupBindings() {
        loginSubject.subscribe { _ in
            self.showLoginScene()
        }.disposed(by: bag)
        offlineModeSubject.subscribe { _ in
            self.showOfflineModeLoginScene()
        }.disposed(by: bag)
    }

    private func showLoginScene() {
        let loginViewController = UIViewController() //LoginViewController in the future
        push(viewController: loginViewController)
    }

    private func showOfflineModeLoginScene() {
        let registerViewController = ViewControllerFactory.get.registerViewController()
        push(viewController: registerViewController)
    }

}

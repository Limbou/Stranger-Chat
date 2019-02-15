//
//  LandingRouter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol LandingRoutable: Router {
    var loginObserver: AnyObserver<Void> { get }
    var registerObserver: AnyObserver<Void> { get }
}

final class LandingRouter: LandingRoutable {

    private let bag = DisposeBag()
    private let loginSubject = PublishSubject<Void>()
    var loginObserver: AnyObserver<Void> {
        return loginSubject.asObserver()
    }
    private let registerSubject = PublishSubject<Void>()
    var registerObserver: AnyObserver<Void> {
        return registerSubject.asObserver()
    }
    weak var viewController: UIViewController?

    init() {
        setupBindings()
    }

    private func setupBindings() {
        loginSubject.subscribe { _ in
            self.showLoginScene()
        }.disposed(by: bag)
        registerSubject.subscribe { _ in
            self.showRegisterScene()
        }.disposed(by: bag)
    }

    private func showLoginScene() {
        let loginViewController = UIViewController() //LoginViewController in the future
        push(viewController: loginViewController)
    }

    private func showRegisterScene() {
        let registerViewController = UIViewController()
        push(viewController: registerViewController) //RegisterViewController in the future
    }

}

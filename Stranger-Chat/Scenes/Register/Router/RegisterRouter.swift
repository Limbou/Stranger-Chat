//
//  RegisterRouter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol RegisterRouter: Router {
    var registerObserver: AnyObserver<Void> { get }
}

final class RegisterRouterImpl: RegisterRouter {

    private let bag = DisposeBag()
    private let registerSubject = PublishSubject<Void>()
    var registerObserver: AnyObserver<Void> {
        return registerSubject.asObserver()
    }
    var viewController: UIViewController?

    init() {
        setupBindings()
    }

    private func setupBindings() {
        registerSubject.subscribe { _ in
            self.goToMainView()
        }.disposed(by: bag)
    }

    private func goToMainView() {

    }

}

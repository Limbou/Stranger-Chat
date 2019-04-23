//
//  RegisterInteractor.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol RegisterInteractor: AnyObject {
    var registerButtonObserver: AnyObserver<Void> { get }
}

final class RegisterInteractorImpl: RegisterInteractor {

    private let presenter: RegisterPresenter
    private let router: RegisterRouter
    private let bag = DisposeBag()
    private let registerSubject = PublishSubject<Void>()
    var registerButtonObserver: AnyObserver<Void> {
        return registerSubject.asObserver()
    }

    init(presenter: RegisterPresenter, router: RegisterRouter) {
        self.presenter = presenter
        self.router = router
        setupBindings()
    }

    private func setupBindings() {
        registerSubject.subscribe { _ in

        }.disposed(by: bag)
    }

}

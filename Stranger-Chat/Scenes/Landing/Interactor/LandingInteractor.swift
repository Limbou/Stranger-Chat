//
//  LandingInteractor.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol LandingInteractor: AnyObject {
    var loginButtonObserver: AnyObserver<Void> { get }
    var registerButtonObserver: AnyObserver<Void> { get }
}

final class LandingInteractorImpl: LandingInteractor {

    private let bag = DisposeBag()
    private let router: LandingRouter
    private let loginSubject = PublishSubject<Void>()
    var loginButtonObserver: AnyObserver<Void> {
        return loginSubject.asObserver()
    }
    private let registerSubject = PublishSubject<Void>()
    var registerButtonObserver: AnyObserver<Void> {
        return registerSubject.asObserver()
    }

    init(router: LandingRouter) {
        self.router = router
        setupBindings()
    }

    private func setupBindings() {
        loginSubject
            .bind(to: router.loginObserver)
            .disposed(by: bag)
        registerSubject
            .bind(to: router.registerObserver)
            .disposed(by: bag)
    }

}

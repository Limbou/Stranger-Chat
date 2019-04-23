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
    var offlineModeButtonObserver: AnyObserver<Void> { get }
}

final class LandingInteractorImpl: LandingInteractor {

    private let bag = DisposeBag()
    private let router: LandingRouter
    private let loginSubject = PublishSubject<Void>()
    private let offlineModeSubject = PublishSubject<Void>()
    var loginButtonObserver: AnyObserver<Void> {
        return loginSubject.asObserver()
    }
    var offlineModeButtonObserver: AnyObserver<Void> {
        return offlineModeSubject.asObserver()
    }

    init(router: LandingRouter) {
        self.router = router
        setupBindings()
    }

    private func setupBindings() {
        loginSubject
            .bind(to: router.loginObserver)
            .disposed(by: bag)
        offlineModeSubject
            .bind(to: router.offlineModeObserver)
            .disposed(by: bag)
    }

}

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
    var loginPressed: PublishSubject<Void> { get }
    var registerPressed: PublishSubject<Void> { get }
    var offlineModePressed: PublishSubject<Void> { get }
}

final class LandingInteractorImpl: LandingInteractor {

    private let bag = DisposeBag()
    private let router: LandingRouter
    let loginPressed = PublishSubject<Void>()
    let registerPressed = PublishSubject<Void>()
    let offlineModePressed = PublishSubject<Void>()

    init(router: LandingRouter) {
        self.router = router
        setupBindings()
    }

    private func setupBindings() {
        loginPressed
            .subscribe({ _ in
                self.router.showLoginScene()
            })
            .disposed(by: bag)
        registerPressed
            .subscribe({ _ in
                self.router.showRegisterScene()
            })
            .disposed(by: bag)
        offlineModePressed
            .subscribe({ _ in
                self.router.showOfflineModeLoginScene()
            })
            .disposed(by: bag)
    }

}

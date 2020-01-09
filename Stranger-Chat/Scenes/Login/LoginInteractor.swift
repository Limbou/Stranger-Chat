//
//  LoginInteractor.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt
import FirebaseAuth

protocol LoginInteractor: AnyObject {
    var loginObserver: PublishSubject<LoginData> { get }
}

final class LoginInteractorImpl: LoginInteractor {

    private let presenter: LoginPresenter
    private let router: LoginRouter
    private let worker: LoginWorker
    private let bag = DisposeBag()
    let loginObserver = PublishSubject<LoginData>()

    init(presenter: LoginPresenter, router: LoginRouter, worker: LoginWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
    }

    private func setupBindings() {
        loginObserver
            .subscribe(onNext: { loginData in
                self.login(with: loginData)
            }).disposed(by: bag)
    }

    private func login(with data: LoginData) {
        presenter.presentLoading()
        worker.login(with: data).subscribe(onNext: { success in
            self.presenter.hideLoading()
            if success {
                self.router.goToHomeScreen()
            }
        }, onError: { error in
            self.handle(error: error)
        }).disposed(by: bag)
    }

    private func handle(error: Error) {
        presenter.hideLoading()
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            presenter.showConnectionError()
            return
        }
        let authErrors: [AuthErrorCode] = [.missingEmail, .invalidEmail, .wrongPassword, .userNotFound]
        if authErrors.contains(errorCode) {
            presenter.showWrongCredentialsError()
        } else if error is EmailUnverifiedError {
            presenter.showEmailUnverifiedError()
        } else {
            presenter.showConnectionError()
        }
    }

}

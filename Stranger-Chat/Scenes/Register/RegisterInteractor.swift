//
//  RegisterInteractor.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation
import RxSwift
import RxSwiftExt

protocol RegisterInteractor: AnyObject {
    var registerObserver: PublishSubject<RegisterData> { get }
}

final class RegisterInteractorImpl: RegisterInteractor {

    private let presenter: RegisterPresenter
    private let router: RegisterRouter
    private let worker: RegisterWorker
    private let bag = DisposeBag()

    let registerObserver = PublishSubject<RegisterData>()

    init(presenter: RegisterPresenter, router: RegisterRouter, worker: RegisterWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
    }

    private func setupBindings() {
        registerObserver
            .subscribe(onNext: { data in
                self.register(with: data)
            }).disposed(by: bag)
    }

    private func register(with data: RegisterData) {
        worker.register(with: data).subscribe(onNext: { success in
            if success {
                self.router.goToMainScreen()
            }
        }, onError: { error in
            self.presenter.show(error: error)
        }).disposed(by: bag)
    }

}

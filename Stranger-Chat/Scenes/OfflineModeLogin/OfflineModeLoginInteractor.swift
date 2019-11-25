//
//  RegisterInteractor.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt

protocol OfflineModeLoginInteractor: AnyObject {
    var offlineModeLoginObserver: PublishSubject<String?> { get }
}

final class OfflineModeLoginInteractorImpl: OfflineModeLoginInteractor {

    private let presenter: OfflineModeLoginPresenter
    private let router: OfflineModeLoginRouter
    private let worker: OfflineModeLoginWorker

    private let bag = DisposeBag()
    let offlineModeLoginObserver = PublishSubject<String?>()

    init(presenter: OfflineModeLoginPresenter, router: OfflineModeLoginRouter, worker: OfflineModeLoginWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
    }

    private func setupBindings() {
        offlineModeLoginObserver
            .unwrap()
            .filter { name in name.isValidName()}
            .subscribe(onNext: { name in
                self.login(name: name)
            })
            .disposed(by: bag)

        offlineModeLoginObserver
            .filter { name in !(name?.isValidName() ?? true) }
            .map { _ in }
            .subscribe(onNext: { _ in
                self.presenter.showWrongNameAlert()
            })
            .disposed(by: bag)
    }

    private func login(name: String) {
        worker.saveUser(name: name)
        router.showMainScreen()
    }

}

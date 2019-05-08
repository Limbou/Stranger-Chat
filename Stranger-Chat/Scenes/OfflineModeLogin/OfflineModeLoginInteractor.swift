//
//  RegisterInteractor.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol OfflineModeLoginInteractor: AnyObject {
    var offlineModeLoginButtonObserver: PublishSubject<String?> { get }
}

final class OfflineModeLoginInteractorImpl: OfflineModeLoginInteractor {

    private let presenter: OfflineModeLoginPresenter
    private let router: OfflineModeLoginRouter
    private let worker: OfflineModeLoginWorker

    private let bag = DisposeBag()
    let offlineModeLoginButtonObserver = PublishSubject<String?>()

    init(presenter: OfflineModeLoginPresenter, router: OfflineModeLoginRouter, worker: OfflineModeLoginWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
    }

    private func setupBindings() {
        offlineModeLoginButtonObserver.subscribe { email in
            print(email)
        }.disposed(by: bag)
    }

}

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

}


final class RegisterInteractorImpl: RegisterInteractor {

    private let presenter: RegisterPresenter
    private let router: RegisterRouter
    private let worker: RegisterWorker
    private let bag = DisposeBag()

    init(presenter: RegisterPresenter, router: RegisterRouter, worker: RegisterWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
    }

    private func setupBindings() {

    }

}

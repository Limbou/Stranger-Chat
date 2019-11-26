//
//  HomeInteractor.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation
import RxSwift
import RxSwiftExt

protocol HomeInteractor: AnyObject {
    var findPressed: PublishSubject<Void> { get }
    var makeVisiblePressed: PublishSubject<Void> { get }
}


final class HomeInteractorImpl: HomeInteractor {

    private let presenter: HomePresenter
    private let router: HomeRouter
    private let worker: HomeWorker
    private let bag = DisposeBag()
    let findPressed = PublishSubject<Void>()
    let makeVisiblePressed = PublishSubject<Void>()

    init(presenter: HomePresenter, router: HomeRouter, worker: HomeWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
    }

    private func setupBindings() {
        findPressed.subscribe(onNext: { _ in
            self.router.goToStrangersBrowser()
        }).disposed(by: bag)

        makeVisiblePressed.subscribe(onNext: { _ in

        }).disposed(by: bag)
    }

}

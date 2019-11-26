//
//  StrangersBrowserInteractor.swift
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

protocol StrangersBrowserInteractor: AnyObject {
    var onWillAppear: PublishSubject<Void> { get }
}


final class StrangersBrowserInteractorImpl: StrangersBrowserInteractor {

    private let presenter: StrangersBrowserPresenter
    private let router: StrangersBrowserRouter
    private let worker: StrangersBrowserWorker
    private let bag = DisposeBag()
    let onWillAppear = PublishSubject<Void>()

    init(presenter: StrangersBrowserPresenter, router: StrangersBrowserRouter, worker: StrangersBrowserWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
    }

    private func setupBindings() {
        onWillAppear.subscribe(onNext: { _ in
            self.startBrowsing()
        })
    }

    private func startBrowsing() {
        print("Browse")
    }

}

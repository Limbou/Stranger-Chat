//
//  ArchiveInteractor.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 29/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation
import RxSwift
import RxSwiftExt

protocol ArchiveInteractor: AnyObject {
    var onViewWillAppear: PublishSubject<[Any]> { get }
}

final class ArchiveInteractorImpl: ArchiveInteractor {

    private let presenter: ArchivePresenter
    private let router: ArchiveRouter
    private let worker: ArchiveWorker
    private let bag = DisposeBag()

    let onViewWillAppear = PublishSubject<[Any]>()
    private var conversationsSubscription: Disposable?

    init(presenter: ArchivePresenter, router: ArchiveRouter, worker: ArchiveWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
    }

    deinit {
        conversationsSubscription?.dispose()
    }

    private func setupBindings() {
        onViewWillAppear.subscribe(onNext: { _ in
            self.handleOnViewWillAppear()
        }).disposed(by: bag)
    }

    private func handleOnViewWillAppear() {
        conversationsSubscription?.dispose()
        conversationsSubscription = worker.getPastConversations().subscribe(onNext: { conversations in
            self.presenter.display(conversations: conversations)
        })
    }

}

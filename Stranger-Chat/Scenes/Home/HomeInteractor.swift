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
    var invitationAccepted: PublishSubject<Void> { get }
}

final class HomeInteractorImpl: HomeInteractor {

    private let presenter: HomePresenter
    private let router: HomeRouter
    private let worker: HomeWorker
    private let bag = DisposeBag()
    let findPressed = PublishSubject<Void>()
    let makeVisiblePressed = PublishSubject<Void>()
    let invitationAccepted = PublishSubject<Void>()
    private var advertising = false {
        didSet {
            toggleAdvertising()
        }
    }

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
            self.advertising.toggle()
        }).disposed(by: bag)

        invitationAccepted.subscribe(onNext: { _ in
            self.handleInvitationAccepted()
        }).disposed(by: bag)
    }

    private func toggleAdvertising() {
        if advertising {
            worker.startAdvertising().subscribe(onNext: { invitation in
                self.presentInvitation(invitation)
            }).disposed(by: bag)
        } else {
            worker.stopAdvertising()
        }
        presenter.setAdvertisingButton(advertising: advertising)
    }

    private func presentInvitation(_ invitation: SessionInvitation) {
        presenter.presentInvitation(from: invitation.peerId.displayName,
                                    additionalInfo: String(fromData: invitation.context))
    }

    private func handleInvitationAccepted() {
        worker.acceptInvitation().subscribe(onNext: { state in
            DispatchQueue.main.async {
                self.handleConnectionStateChange(state)
            }
        }).disposed(by: bag)
    }

    private func handleConnectionStateChange(_ state: ConnectionState) {
        switch state {
        case .connecting:
            break
        case .connected:
            router.goToChat()
        case .disconnected:
            print("Disconnected!")
        }
    }

}

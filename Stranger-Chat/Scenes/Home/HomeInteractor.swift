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
    var invitationAccepted: PublishSubject<Bool> { get }
}

final class HomeInteractorImpl: HomeInteractor {

    private let presenter: HomePresenter
    private let router: HomeRouter
    private let worker: HomeWorker
    private let bag = DisposeBag()
    let findPressed = PublishSubject<Void>()
    let makeVisiblePressed = PublishSubject<Void>()
    let invitationAccepted = PublishSubject<Bool>()
    private var advertising = false {
        didSet {
            toggleAdvertising()
        }
    }

    private var subscription: Disposable?
    private var subscription2: Disposable?

    init(presenter: HomePresenter, router: HomeRouter, worker: HomeWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
    }

    deinit {
        subscription?.dispose()
        subscription2?.dispose()
    }

    private func setupBindings() {
        findPressed.subscribe(onNext: { _ in
            self.router.goToStrangersBrowser()
        }).disposed(by: bag)

        makeVisiblePressed.subscribe(onNext: { _ in
            self.advertising.toggle()
        }).disposed(by: bag)

        invitationAccepted.subscribe(onNext: { accepted in
            self.handleInvitation(accepted: accepted)
        }).disposed(by: bag)
    }

    private func toggleAdvertising() {
        if advertising {
            subscription2?.dispose()
            subscription2 = worker.startAdvertising().subscribe(onNext: { invitation in
                self.presentInvitation(invitation)
            })
        } else {
            worker.stopAdvertising()
        }
        presenter.setAdvertisingButton(advertising: advertising)
    }

    private func presentInvitation(_ invitation: SessionInvitation) {
        presenter.presentInvitation(from: invitation.peerId.displayName,
                                    additionalInfo: String(fromData: invitation.context))
    }

    private func handleInvitation(accepted: Bool) {
        guard accepted else {
            worker.declineInvitation()
            return
        }
        subscription?.dispose()
        subscription = worker.acceptInvitation().subscribe(onNext: { state in
            DispatchQueue.main.async {
                self.handleConnectionStateChange(state)
            }
        })
    }

    private func handleConnectionStateChange(_ state: ConnectionState) {
        switch state {
        case .connecting:
            break
        case .connected:
            advertising.toggle()
            router.goToChat()
        case .disconnected:
            print(UIDevice.current.name)
            print("Disconnected!")
        }
    }

}

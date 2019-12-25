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
    var onWillDisappear: PublishSubject<[Any]> { get }
    var findPressed: PublishSubject<Void> { get }
    var makeVisiblePressed: PublishSubject<Void> { get }
    var invitationAccepted: PublishSubject<Bool> { get }
}

final class HomeInteractorImpl: HomeInteractor {

    private let presenter: HomePresenter
    private let router: HomeRouter
    private let worker: HomeWorker
    private let bag = DisposeBag()
    let onWillDisappear = PublishSubject<[Any]>()
    let findPressed = PublishSubject<Void>()
    let makeVisiblePressed = PublishSubject<Void>()
    let invitationAccepted = PublishSubject<Bool>()
    private var shouldGoOnline = false
    private var shouldAdvertise = false {
        didSet {
            toggleAdvertising()
        }
    }

    private var invitationSubscription: Disposable?
    private var advertisingSubscription: Disposable?

    init(presenter: HomePresenter, router: HomeRouter, worker: HomeWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
    }

    deinit {
        invitationSubscription?.dispose()
        advertisingSubscription?.dispose()
    }

    private func setupBindings() {
        onWillDisappear.subscribe(onNext: { _ in
            self.shouldAdvertise = false
        }).disposed(by: bag)

        findPressed.subscribe(onNext: { _ in
            self.router.goToStrangersBrowser()
        }).disposed(by: bag)

        makeVisiblePressed.subscribe(onNext: { _ in
            self.shouldAdvertise.toggle()
        }).disposed(by: bag)

        invitationAccepted.subscribe(onNext: { accepted in
            self.handleInvitation(accepted: accepted)
        }).disposed(by: bag)
    }

    private func toggleAdvertising() {
        if shouldAdvertise {
            advertisingSubscription?.dispose()
            advertisingSubscription = worker.startAdvertising().subscribe(onNext: { invitation in
                self.handleReceived(invitation: invitation)
            })
        } else {
            worker.stopAdvertising()
        }
        presenter.setAdvertisingButton(advertising: shouldAdvertise)
    }

    private func handleReceived(invitation: SessionInvitation) {
        if let invitationContext = getInvitationContext(data: invitation.context),
            let isOnline = invitationContext[PeerConstants.isOnlineKey] {
            shouldGoOnline = isOnline
        }
        presenter.presentInvitation(from: invitation.peerId.displayName, additionalInfo: nil)
    }

    private func getInvitationContext(data: Data?) -> [String: Bool]? {
        guard let data = data else {
            return nil
        }
        do {
            let context = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Bool]
            return context
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    private func handleInvitation(accepted: Bool) {
        guard accepted else {
            worker.declineInvitation()
            return
        }
        invitationSubscription?.dispose()
        invitationSubscription = worker.acceptInvitation().subscribe(onNext: { state in
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
            shouldAdvertise.toggle()
            router.goToChat(online: shouldGoOnline)
        case .disconnected:
            print("Disconnected!")
        }
    }

}

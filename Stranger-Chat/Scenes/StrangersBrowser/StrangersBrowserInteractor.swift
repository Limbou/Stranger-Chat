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
import MultipeerConnectivity

protocol StrangersBrowserInteractor: AnyObject {
    var onWillAppear: PublishSubject<[Any]> { get }
    var onWillDisappear: PublishSubject<[Any]> { get }
    var selectCell: PublishSubject<Int> { get }
}


final class StrangersBrowserInteractorImpl: StrangersBrowserInteractor {

    private let presenter: StrangersBrowserPresenter
    private let router: StrangersBrowserRouter
    private let worker: StrangersBrowserWorker
    private let bag = DisposeBag()
    private var discoveredUsers: [DiscoverableUser] = []
    private var shouldGoOnline = false
    let onWillAppear = PublishSubject<[Any]>()
    let onWillDisappear = PublishSubject<[Any]>()
    let selectCell = PublishSubject<Int>()

    private var invitationSubscription: Disposable?
    private var browsingSubscription: Disposable?

    init(presenter: StrangersBrowserPresenter, router: StrangersBrowserRouter, worker: StrangersBrowserWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
    }

    deinit {
        invitationSubscription?.dispose()
        browsingSubscription?.dispose()
    }

    private func setupBindings() {
        onWillAppear.subscribe(onNext: { _ in
            self.startBrowsing()
        }).disposed(by: bag)

        onWillDisappear.subscribe(onNext: { _ in
            self.stopBrowsing()
        }).disposed(by: bag)

        selectCell.subscribe(onNext: { index in
            self.selectedCell(index)
        }).disposed(by: bag)
    }

    private func startBrowsing() {
        discoveredUsers = []
        presenter.display(users: [])
        browsingSubscription?.dispose()
        browsingSubscription = worker.startBrowsing().subscribe(onNext: { discoveredUsers in
            self.discoveredUsers = discoveredUsers
            self.presenter.display(users: discoveredUsers.map({ $0.peer.displayName }))
        })
    }

    private func stopBrowsing() {
        worker.stopBrowsing()
    }

    private func selectedCell(_ index: Int) {
        guard let user = discoveredUsers[safe: index] else {
            print("No user at given index")
            return
        }
        let context = prepareInvitationContext(for: user.discoveryInfo)
        invitationSubscription?.dispose()
        invitationSubscription = worker.sendInvitationTo(user: user, context: context).subscribe(onNext: { state in
            DispatchQueue.main.async {
                 self.handleConnectionStateChange(state: state)
            }
        })
        presenter.presentInvitationSentAlert()
    }

    private func prepareInvitationContext(for info: [String: String]?) -> Data? {
        guard let isOnline = info?[PeerConstants.isOnlineKey]?.bool,
            isOnline,
            worker.isOnline() else {
                shouldGoOnline = false
                return nil
        }
        let goOnlineContext = [PeerConstants.isOnlineKey: true]
        do {
            let context = try JSONSerialization.data(withJSONObject: goOnlineContext, options: .prettyPrinted)
            shouldGoOnline = true
            return context
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    private func handleConnectionStateChange(state: ConnectionState) {
        switch state {
        case .connecting:
            break
        case .connected:
            stopBrowsing()
            router.goToChat(online: shouldGoOnline)
        case .disconnected:
            print("Disconnected!")
        }
    }

}

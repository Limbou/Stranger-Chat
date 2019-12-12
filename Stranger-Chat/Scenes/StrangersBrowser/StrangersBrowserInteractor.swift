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
    private var discoveredUsers: [MCPeerID] = []
    let onWillAppear = PublishSubject<[Any]>()
    let onWillDisappear = PublishSubject<[Any]>()
    let selectCell = PublishSubject<Int>()

    private var subscription: Disposable?
    private var subscription2: Disposable?

    init(presenter: StrangersBrowserPresenter, router: StrangersBrowserRouter, worker: StrangersBrowserWorker) {
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
        subscription2?.dispose()
        subscription2 = worker.startBrowsing().subscribe(onNext: { discoveredUsers in
            self.discoveredUsers = discoveredUsers
            self.presenter.display(users: discoveredUsers.map({ $0.displayName }))
        })
    }

    private func stopBrowsing() {
        worker.stopBrowsing()
    }

    private func selectedCell(_ index: Int) {
        subscription?.dispose()
        subscription = worker.sendInvitationTo(peerIndex: index).subscribe(onNext: { state in
            DispatchQueue.main.async {
                 self.handleConnectionStateChange(state: state)
            }
        })
        presenter.presentInvitationSentAlert()
    }

    private func handleConnectionStateChange(state: ConnectionState) {
        switch state {
        case .connecting:
            break
        case .connected:
            stopBrowsing()
            router.goToChat()
        case .disconnected:
            print("Disconnected!")
        }
    }

}

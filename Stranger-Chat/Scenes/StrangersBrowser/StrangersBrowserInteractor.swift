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

    init(presenter: StrangersBrowserPresenter, router: StrangersBrowserRouter, worker: StrangersBrowserWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
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
        worker.startBrowsing().subscribe(onNext: { discoveredUsers in
            self.discoveredUsers = discoveredUsers
            self.presenter.display(users: discoveredUsers.map({ $0.displayName }))
        }).disposed(by: bag)
    }

    private func stopBrowsing() {
        worker.stopBrowsing()
    }

    private func selectedCell(_ index: Int) {
        worker.sendInvitationTo(peerIndex: index).subscribe(onNext: { state in
            DispatchQueue.main.async {
                self.handleConnectionStateChange(state: state)
            }
        }).disposed(by: bag)
        presenter.presentInvitationSentAlert()
    }

    private func handleConnectionStateChange(state: ConnectionState) {
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

//
//  ChatInteractor.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 08/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation
import RxSwift
import RxSwiftExt

protocol ChatInteractor: AnyObject {
    var sendPressed: PublishSubject<String?> { get }
    var imagePressed: PublishSubject<Void> { get }
}

final class ChatInteractorImpl: ChatInteractor {

    private let presenter: ChatPresenter
    private let router: ChatRouter
    private let worker: ChatWorker
    private let bag = DisposeBag()
    private var messages = [String]()

    let sendPressed = PublishSubject<String?>()
    let imagePressed = PublishSubject<Void>()

    init(presenter: ChatPresenter, router: ChatRouter, worker: ChatWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
        setupBindings()
    }

    private func setupBindings() {
        sendPressed.subscribe(onNext: { text in
            self.handleSendPress(text)
        }).disposed(by: bag)

        imagePressed.subscribe(onNext: { _ in
            self.handleImagePress()
        }).disposed(by: bag)

        worker.receivedMessages.subscribe(onNext: { message in
            self.handleReceived(message: message)
        }).disposed(by: bag)
    }

    private func handleSendPress(_ text: String?) {
        guard let text = text else {
            return
        }
        worker.send(message: text)
    }

    private func handleImagePress() {
        print("Image pressed")
    }

    private func handleReceived(message: String) {
        messages.append(message)
        presenter.display(messages: messages)
    }

}

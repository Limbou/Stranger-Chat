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

final class ChatOnlineInteractor: ChatInteractor {

    private let presenter: ChatPresenter
    private let router: ChatRouter
    private let worker: ChatOnlineWorker
    private let bag = DisposeBag()
    private var messages = [ChatMessage]()

    let sendPressed = PublishSubject<String?>()
    let imagePicked = PublishSubject<UIImage>()
    let dismissPressed = PublishSubject<Void>()
    let cellPressed = PublishSubject<Int>()

    init(presenter: ChatPresenter, router: ChatRouter, worker: ChatOnlineWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
    }

    func setup() {
        setupBindings()
        worker.initializeConnection()
        setupTitle()
    }

    private func setupBindings() {
        sendPressed.subscribe(onNext: { text in
            self.handleSendPress(text)
        }).disposed(by: bag)

        imagePicked.subscribe(onNext: { image in
            self.handleImagePick(image: image)
        }).disposed(by: bag)

        dismissPressed.subscribe(onNext: { _ in
            self.handleDismissPress()
        }).disposed(by: bag)

        worker.receivedMessages.subscribe(onNext: { messages in
            self.presenter.display(messages: messages)
        }).disposed(by: bag)

        worker.disconnected.subscribe(onNext: { _ in
            self.handleDisconnect()
        }).disposed(by: bag)

        cellPressed.subscribe(onNext: { index in
            self.handleCellPressed(index: index)
        }).disposed(by: bag)
    }

    private func setupTitle() {
        let userName = worker.getOtherUserName()
        presenter.setup(title: userName)
    }

    private func handleCellPressed(index: Int) {
        guard let message = messages[safe: index], let image = message.image else {
            return
        }
        router.navigateToImageView(image: image)
    }

    private func handleSendPress(_ text: String?) {
        guard let text = text, !text.isEmpty else {
            return
        }
        worker.send(message: text)
    }

    private func handleImagePick(image: UIImage) {
        worker.send(image: image)
    }

    private func handleDismissPress() {
//        worker.send(message: ChatSecretMessages.endChat.rawValue)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.endChat()
        }
    }

    private func handleReceived(message: ChatMessage) {
        if message.content == ChatSecretMessages.endChat.rawValue {
            endChat()
            return
        }
        messages.append(message)
        presenter.display(messages: messages)
    }

    private func handleDisconnect() {
//        endChat()
    }

    private func endChat() {
        worker.disconnectFromSession()
        router.dismissView()
    }

}

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
    var imagePicked: PublishSubject<UIImage> { get }
    var dismissPressed: PublishSubject<Void> { get }
    func setup()
}

final class ChatOfflineInteractor: ChatInteractor {

    private let presenter: ChatPresenter
    private let router: ChatRouter
    private let worker: ChatOfflineWorker
    private let bag = DisposeBag()
    private var messages = [ChatMessage]()

    let sendPressed = PublishSubject<String?>()
    let imagePicked = PublishSubject<UIImage>()
    let dismissPressed = PublishSubject<Void>()

    init(presenter: ChatPresenter, router: ChatRouter, worker: ChatOfflineWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
    }

    func setup() {
        setupBindings()
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

        worker.receivedMessages.subscribe(onNext: { message in
            self.handleReceived(message: message)
        }).disposed(by: bag)

        worker.disconnected.subscribe(onNext: { _ in
            self.handleDisconnect()
        }).disposed(by: bag)
    }

    private func handleSendPress(_ text: String?) {
        guard let text = text, !text.isEmpty else {
            return
        }
        worker.send(message: text)
        let chatMessage = ChatMessage(content: text, isAuthor: true)
        messages.append(chatMessage)
        DispatchQueue.main.async {
            self.presenter.display(messages: self.messages)
        }
    }

    private func handleImagePick(image: UIImage) {
        worker.send(image: image)
        let chatMessage = ChatMessage(image: image, isAuthor: true)
        messages.append(chatMessage)
        DispatchQueue.main.async {
            self.presenter.display(messages: self.messages)
        }
    }

    private func handleDismissPress() {
        worker.send(message: ChatSecretMessages.endChat.rawValue)
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
        endChat()
    }

    private func endChat() {
        worker.disconnectFromSession()
        router.dismissView()
    }

}

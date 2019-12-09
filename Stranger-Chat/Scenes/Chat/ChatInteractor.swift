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
    var dismissPressed: PublishSubject<Void> { get }
    func setupBindings()
}

final class ChatInteractorImpl: ChatInteractor {

    private let presenter: ChatPresenter
    private let router: ChatRouter
    private let worker: ChatWorker
    private let bag = DisposeBag()
    private var messages = [ChatMessage]()

    let sendPressed = PublishSubject<String?>()
    let imagePressed = PublishSubject<Void>()
    let dismissPressed = PublishSubject<Void>()

    init(presenter: ChatPresenter, router: ChatRouter, worker: ChatWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
    }

    func setupBindings() {
        sendPressed.subscribe(onNext: { text in
            self.handleSendPress(text)
        }).disposed(by: bag)

        imagePressed.subscribe(onNext: { _ in
            self.handleImagePress()
        }).disposed(by: bag)

        dismissPressed.subscribe(onNext: { _ in
            self.handleDismissPress()
        }).disposed(by: bag)

        worker.receivedMessages.subscribe(onNext: { message in
            self.handleReceived(message: message)
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

    private func handleImagePress() {
        print("Image pressed")
    }

    private func handleDismissPress() {
        worker.send(message: ChatSecretMessages.endChat.rawValue)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.endChat()
        }
    }

    private func handleReceived(message: String) {
        if message == ChatSecretMessages.endChat.rawValue {
            endChat()
            return
        }
        let chatMessage = ChatMessage(content: message, isAuthor: false)
        messages.append(chatMessage)
        presenter.display(messages: messages)
    }

    private func endChat() {
        worker.disconnectFromSession()
        router.dismissView()
    }

}

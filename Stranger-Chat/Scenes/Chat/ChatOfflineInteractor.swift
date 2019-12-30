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
    var cellPressed: PublishSubject<Int> { get }
    func setup()
}

final class ChatOfflineInteractor: ChatInteractor {

    private let presenter: ChatPresenter
    private let router: ChatRouter
    private let worker: ChatOfflineWorker
    private let bag = DisposeBag()
    private var conversation = LocalConversation()
    private var imageSendSubscription: Disposable?
    private var connectionClosed = false

    let sendPressed = PublishSubject<String?>()
    let imagePicked = PublishSubject<UIImage>()
    let dismissPressed = PublishSubject<Void>()
    let cellPressed = PublishSubject<Int>()

    init(presenter: ChatPresenter, router: ChatRouter, worker: ChatOfflineWorker) {
        self.presenter = presenter
        self.router = router
        self.worker = worker
    }

    deinit {
        imageSendSubscription?.dispose()
    }

    func setup() {
        setupBindings()
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

        worker.receivedMessages.subscribe(onNext: { message in
            self.handleReceived(message: message)
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
        guard let message = conversation.messages[safe: index], let image = message.image else {
            return
        }
        router.navigateToImageView(image: image)
    }

    private func handleSendPress(_ text: String?) {
        guard let text = text, !text.isEmpty else {
            return
        }
        worker.send(message: text)
        guard let chatMessage = worker.createChatMessageWith(content: text, image: nil) else {
            print("Could not create message: no user")
            return
        }
        conversation.localMessages.append(chatMessage)
        worker.save(conversation: conversation)
        DispatchQueue.main.async {
            self.presenter.display(messages: self.conversation.localMessages)
        }
    }

    private func handleImagePick(image: UIImage) {
        guard let chatMessage = worker.createChatMessageWith(content: nil, image: image),
            let imagePath = worker.getImagePath(messageId: chatMessage.messageId) else {
            print("Could not get image path or create chat message")
            return
        }
        chatMessage.imagePath = imagePath
        presenter.presentSendingImageAlert()
        imageSendSubscription?.dispose()
        imageSendSubscription = worker.send(image: image, messageId: chatMessage.messageId).subscribe(onNext: { fractionComplete in
            self.handleFractionCompleteChange(value: fractionComplete, chatMessage: chatMessage)
        }, onError: { _ in
            self.presenter.hideSendingImageAlert()
        })
    }

    private func handleFractionCompleteChange(value: Double?, chatMessage: ChatMessage) {
        guard let fraction = value, fraction >= 1 else {
            return
        }
        conversation.localMessages.append(chatMessage)
        DispatchQueue.main.async {
            self.presenter.display(messages: self.conversation.localMessages)
            self.worker.save(conversation: self.conversation)
            self.presenter.hideSendingImageAlert()
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
            handleDisconnect()
            return
        }
        conversation.localMessages.append(message)
        presenter.display(messages: conversation.localMessages)
        worker.save(conversation: conversation)
    }

    private func handleDisconnect() {
        guard !connectionClosed else {
            return
        }
        DispatchQueue.main.async {
            self.presenter.presentConnectionLostAlert()
            self.endChat()
            self.connectionClosed = true
        }
    }

    private func endChat() {
        worker.disconnectFromSession()
        router.dismissView()
    }

}

//
//  ChatPresenter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 08/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import UIKit

final class ChatMessageViewModel {

    let content: String?
    let image: UIImage?
    let isAuthor: Bool

    init(content: String?, image: UIImage?, isAuthor: Bool) {
        self.content = content
        self.image = image
        self.isAuthor = isAuthor
    }
}

protocol ChatDisplayable: AnyObject {
    func display(messages: [ChatMessageViewModel])
    func setup(title: String)
    func presentConnectionLostAlert()
    func presentSendingImageAlert()
    func hideSendingImageAlert()
}

protocol ChatPresenter: AnyObject {
    var viewController: ChatDisplayable? { get set }
    func display(messages: [ChatMessage])
    func setup(title: String)
    func presentConnectionLostAlert()
    func presentSendingImageAlert()
    func hideSendingImageAlert()
}

final class ChatPresenterImpl: ChatPresenter {

    weak var viewController: ChatDisplayable?
    private let currentUserRepository: CurrentUserRepository

    init(currentUserRepository: CurrentUserRepository) {
        self.currentUserRepository = currentUserRepository
    }

    func display(messages: [ChatMessage]) {
        guard let userId = currentUserRepository.currentUser()?.userId else {
            print("No user")
            return
        }
        let messageViewModels = messages.map { message in
            return ChatMessageViewModel(content: message.content,
                                        image: message.image,
                                        isAuthor: message.senderId == userId)
        }
        viewController?.display(messages: messageViewModels)
    }

    func setup(title: String) {
        viewController?.setup(title: title)
    }

    func presentConnectionLostAlert() {
        viewController?.presentConnectionLostAlert()
    }

    func presentSendingImageAlert() {
        viewController?.presentSendingImageAlert()
    }

    func hideSendingImageAlert() {
        viewController?.hideSendingImageAlert()
    }

}

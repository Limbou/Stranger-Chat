//
//  ArchiveChatPresenter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 02/01/2020.
//  Copyright © 2020 Jakub Danielczyk. All rights reserved.
//

import Foundation

protocol ArchiveChatDisplayable: Displayable {
    func display(messages: [ChatMessageViewModel])
    func setup(title: String)
}

protocol ArchiveChatPresenter: AnyObject {
    var viewController: ArchiveChatDisplayable? { get set }
    func display(messages: [Message])
    func setup(title: String)
    func showLoading()
    func hideLoading()
}

final class ArchiveChatPresenterImpl: ArchiveChatPresenter {

    weak var viewController: ArchiveChatDisplayable?
    private let currentUserRepository: CurrentUserRepository

    init(currentUserRepository: CurrentUserRepository) {
        self.currentUserRepository = currentUserRepository
    }

    func display(messages: [Message]) {
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

    func showLoading() {
        viewController?.presentLoading()
    }

    func hideLoading() {
        viewController?.hideLoading()
    }

}

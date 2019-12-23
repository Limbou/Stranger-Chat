//
//  ChatPresenter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 08/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation

protocol ChatDisplayable: AnyObject {
    func display(messages: [ChatMessage])
    func setup(title: String)
}

protocol ChatPresenter: AnyObject {
    var viewController: ChatDisplayable? { get set }
    func display(messages: [ChatMessage])
    func setup(title: String)
}

final class ChatPresenterImpl: ChatPresenter {

    weak var viewController: ChatDisplayable?

    func display(messages: [ChatMessage]) {
        viewController?.display(messages: messages)
    }

    func setup(title: String) {
        viewController?.setup(title: title)
    }

}

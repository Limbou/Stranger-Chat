//
//  ArchivePresenter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 29/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation

protocol ArchiveDisplayable: AnyObject {
    func display(conversations: [Conversation])
}

protocol ArchivePresenter: AnyObject {
    var viewController: ArchiveDisplayable? { get set }
    func display(conversations: [Conversation])
}

final class ArchivePresenterImpl: ArchivePresenter {

    weak var viewController: ArchiveDisplayable?

    func display(conversations: [Conversation]) {
        viewController?.display(conversations: conversations)
    }

}

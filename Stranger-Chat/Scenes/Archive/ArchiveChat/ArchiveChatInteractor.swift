//
//  ArchiveChatInteractor.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 02/01/2020.
//  Copyright © 2020 Jakub Danielczyk. All rights reserved.
//

import Foundation
import RxSwift

protocol ArchiveChatInteractor: AnyObject {
    var onViewDidLoad: PublishSubject<Conversation> { get }
}

final class ArchiveChatInteractorImpl: ArchiveChatInteractor {

    private let presenter: ArchiveChatPresenter
    private let worker: ArchiveChatWorker
    private let bag = DisposeBag()

    let onViewDidLoad = PublishSubject<Conversation>()

    init(presenter: ArchiveChatPresenter, worker: ArchiveChatWorker) {
        self.presenter = presenter
        self.worker = worker
        setupBindings()
    }

    private func setupBindings() {
        onViewDidLoad.subscribe(onNext: { conversation in
            self.handleOnViewDidLoad(conversation)
        }).disposed(by: bag)
    }

    private func handleOnViewDidLoad(_ conversation: Conversation) {
        presenter.showLoading()
        presenter.setup(title: conversation.conversatorName)
        worker.prepare(messages: conversation.messages).subscribe(onNext: { messages in
            self.presenter.display(messages: messages)
            self.presenter.hideLoading()
        }).disposed(by: bag)

    }

}

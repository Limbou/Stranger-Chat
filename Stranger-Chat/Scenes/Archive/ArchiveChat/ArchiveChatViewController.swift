//
//  ArchiveChatViewController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 02/01/2020.
//  Copyright © 2020 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class ArchiveChatViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    private let conversation: Conversation
    private let interactor: ArchiveChatInteractor
    private let cellFactory: ChatCellFactory

    private var messages: [ChatMessageViewModel] = []

    init(conversation: Conversation, interactor: ArchiveChatInteractor, cellFactory: ChatCellFactory) {
        self.conversation = conversation
        self.interactor = interactor
        self.cellFactory = cellFactory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupCells()
        interactor.onViewDidLoad.onNext(conversation)
    }

    private func setupTableView() {
        tableView.dataSource = self
    }

    private func setupCells() {
        cellFactory.registerCells(tableView: tableView)
    }

}

extension ArchiveChatViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        return cellFactory.prepareCell(from: message, tableView: tableView)
    }

}

extension ArchiveChatViewController: ArchiveChatDisplayable {

    func display(messages: [ChatMessageViewModel]) {
        self.messages = messages
        tableView.reloadData()
    }

    func setup(title: String) {
        self.title = title
    }

}

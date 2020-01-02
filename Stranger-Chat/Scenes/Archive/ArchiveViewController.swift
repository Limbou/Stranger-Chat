//
//  ArchiveViewController.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 29/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import UIKit
import RxSwift
import RxCocoa

private enum Constants {

}

final class ArchiveViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    private let interactor: ArchiveInteractor
    private let bag = DisposeBag()

    private var conversations: [Conversation] = []

    init(interactor: ArchiveInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupRefreshControl()
        setupTableView()
    }

    private func setupBindings() {
        rx.methodInvoked(#selector(viewWillAppear(_:)))
            .bind(to: interactor.onViewWillAppear)
            .disposed(by: bag)

        tableView.rx.itemSelected
            .bind(to: interactor.cellSelected)
            .disposed(by: bag)
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.contentOffset = CGPoint(x: 0, y: -refreshControl.frame.size.height)
        tableView.refreshControl?.beginRefreshing()
    }

    @objc
    private func handleRefresh() {
        interactor.onViewWillAppear.onNext([])
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(ConversationCell.self)
    }

}

extension ArchiveViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let conversation = conversations[safe: indexPath.row],
            let cell = tableView.dequeue(ConversationCell.self) as? ConversationCell else {
            return UITableViewCell()
        }
        cell.name.text = conversation.conversatorName
        cell.isOnline = conversation.isOnline
        cell.numberOfMessages = conversation.messages.count
        return cell
    }

}

extension ArchiveViewController: ArchiveDisplayable {

    func display(conversations: [Conversation]) {
        self.conversations = conversations
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }

}

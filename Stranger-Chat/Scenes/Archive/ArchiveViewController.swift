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
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc
    private func handleRefresh() {
        interactor.onViewWillAppear.onNext([])
    }

    private func setupTableView() {
        tableView.dataSource = self
    }

}

extension ArchiveViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let conversation = conversations[safe: indexPath.row] else {
            return UITableViewCell()
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = conversation.conversationId
        cell.tintColor = .white
        cell.backgroundColor = .red
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

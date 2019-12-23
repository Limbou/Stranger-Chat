//
//  StrangersBrowserViewController.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import UIKit
import RxSwift
import RxCocoa

private enum Constants {
    static let invitationSentTitle = "strangerBrowser.invitationSent.title"
    static let invitationSentBody = "strangerBrowser.invitationSent.body"
    static let invitationDeclinedTitle = "strangerBrowse.invitationDeclined.title"
    static let invitationDeclinedBody = "strangerBrowse.invitationDeclined.body"
}

final class StrangersBrowserViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    private let noUsersView = EmptyTableView(frame: .zero)
    private let interactor: StrangersBrowserInteractor
    private let bag = DisposeBag()
    private var foundUsers: [DisplayableFoundUser] = []
    private var invitationAlert: UIAlertController?

    init(interactor: StrangersBrowserInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let browsing = Provider.get.instanceOf(BrowsingViewController.self)
        add(child: browsing)
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            browsing.hide()
        }
    }

    private func setupBindings() {
        rx.methodInvoked(#selector(viewWillAppear(_:)))
            .bind(to: interactor.onWillAppear)
            .disposed(by: bag)

        rx.methodInvoked(#selector(viewWillDisappear(_:)))
            .bind(to: interactor.onWillDisappear)
            .disposed(by: bag)
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StrangerCell.self)
    }

}

extension StrangersBrowserViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(StrangerCell.self) as? StrangerCell,
            let user = foundUsers[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.nameLabel.text = user.name
        cell.isOnline = user.isOnline
        return cell
    }

}

extension StrangersBrowserViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(foundUsers[indexPath.row])
        interactor.selectCell.onNext(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension StrangersBrowserViewController: StrangersBrowserDisplayable {

    func display(users: [DisplayableFoundUser]) {
        foundUsers = users
        tableView.reloadData()
        tableView.backgroundView = foundUsers.isEmpty ? noUsersView : nil
    }

    func presentInvitationSentAlert(user: String) {
        invitationAlert = AlertBuilder.shared.buildNoButtonsAlert(with: Constants.invitationSentTitle.localized(),
                                                     message: Constants.invitationSentBody.localized() + user)
        guard let alert = invitationAlert else {
            return
        }
        alert.addActivityIndicator()
        present(alert, animated: true, completion: nil)
    }

    func presentInvitationDeclinedAlert() {
        invitationAlert?.dismiss(animated: true, completion: nil)
        let alert = AlertBuilder.shared.buildOkAlert(with: Constants.invitationDeclinedTitle.localized(),
                                                     message: Constants.invitationDeclinedBody.localized()) { _ in }
        present(alert, animated: true, completion: nil)
    }

    func hideInvitationSentAlert() {
        invitationAlert?.dismiss(animated: true, completion: nil)
    }

}

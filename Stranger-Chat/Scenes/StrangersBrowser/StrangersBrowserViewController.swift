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

}

final class StrangersBrowserViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private let interactor: StrangersBrowserInteractor
    private let bag = DisposeBag()
    private var userNames: [String] = []

    init(interactor: StrangersBrowserInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupBindings()
    }

    private func setupBindings() {
        rx.methodInvoked(#selector(viewWillAppear(_:)))
            .bind(to: interactor.onWillAppear)
            .disposed(by: bag)
    }

}

extension StrangersBrowserViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = userNames[indexPath.row]
        return cell
    }

}

extension StrangersBrowserViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(userNames[indexPath.row])
        
    }

}

extension StrangersBrowserViewController: StrangersBrowserDisplayable {

    func display(users: [String]) {
        userNames = users
        tableView.reloadData()
    }

    func presentInvitationSentAlert() {
        
    }

}

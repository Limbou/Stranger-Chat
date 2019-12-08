//
//  ChatViewController.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 08/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import UIKit
import RxSwift
import RxCocoa

private enum Constants {

}

final class ChatViewController: UIViewController {

    private let interactor: ChatInteractor
    private let bag = DisposeBag()
    private var messages = [String]()

    @IBOutlet var tableView: UITableView!
    @IBOutlet var inputField: ChatInputField!
    @IBOutlet var inputBottomConstraint: NSLayoutConstraint!

    init(interactor: ChatInteractor) {
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
        setupObservers()
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            inputBottomConstraint.constant += keyboardSize.height
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        inputBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    private func setupBindings() {
        inputField.sendButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map({ self.inputField.inputField.text })
            .bind(to: interactor.sendPressed)
            .disposed(by: bag)

        inputField.imageButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: interactor.imagePressed)
            .disposed(by: bag)
    }

}

extension ChatViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }

}

extension ChatViewController: UITableViewDelegate {

}

extension ChatViewController: ChatDisplayable {

    func display(messages: [String]) {
        self.messages = messages
        tableView.reloadData()
    }

}

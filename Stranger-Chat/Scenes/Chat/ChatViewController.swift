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

final class ChatViewController: UIViewController, UINavigationControllerDelegate {

    private let interactor: ChatInteractor
    private let cellFactory: ChatCellFactory
    private let bag = DisposeBag()
    private var messages = [ChatMessage]()
    private let imagePicker = UIImagePickerController()

    @IBOutlet var tableView: UITableView!
    @IBOutlet var inputField: ChatInputField!
    @IBOutlet var inputBottomConstraint: NSLayoutConstraint!

    init(interactor: ChatInteractor, cellFactory: ChatCellFactory) {
        self.interactor = interactor
        self.cellFactory = cellFactory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        imagePicker.delegate = self
        setupNavbar()
        setupBindings()
        setupObservers()
        cellFactory.registerCells(tableView: tableView)
    }

    private func setupNavbar() {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close,
                                     target: self,
                                     action: #selector(dismissClicked))
        navigationItem.leftBarButtonItem = button
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
        interactor.setup() //Workaround for swinject's problem causing interactor to init 3 times and though call setupBindings 3 times
        inputField.sendButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map({ self.inputField.inputField.text })
            .subscribe(onNext: { message in
                self.interactor.sendPressed.onNext(message)
                self.inputField.inputField.text = ""
            })
            .disposed(by: bag)

        inputField.imageButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.pickImage()
            })
            .disposed(by: bag)
    }

    @objc
    private func dismissClicked() {
        interactor.dismissPressed.onNext(())
    }

    private func pickImage() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

}

extension ChatViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        return cellFactory.prepareCell(from: message, tableView: tableView)
    }

}

extension ChatViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.cellPressed.onNext(indexPath.row)
    }

}

extension ChatViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            print("Error picking image")
            return
        }
        interactor.imagePicked.onNext(image)
    }

}

extension ChatViewController: ChatDisplayable {

    func display(messages: [ChatMessage]) {
        self.messages = messages
        tableView.reloadData()
        if !messages.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }

    func setup(title: String) {
        self.title = title
    }

}

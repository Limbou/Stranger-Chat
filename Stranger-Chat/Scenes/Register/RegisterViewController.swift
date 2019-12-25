//
//  RegisterViewController.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import UIKit
import RxSwift
import RxCocoa

private enum Constants {
    static let title = "register.title"
    static let errorTitle = "register.error.title"
}

final class RegisterViewController: UIViewController {

    private let interactor: RegisterInteractor
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var registerButton: RoundButton!
    private let bag = DisposeBag()

    init(interactor: RegisterInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title.localized()
        setupBindings()
        setupDelegates()
    }

    private func setupBindings() {
        registerButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .map({ RegisterData(displayName: self.nicknameTextField.text ?? "",
                                email: self.emailTextField.text ?? "",
                                password: self.passwordTextField.text ?? "") })
            .bind(to: interactor.registerObserver)
            .disposed(by: bag)
    }

    private func setupDelegates() {
        nicknameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

}

extension RegisterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}

extension RegisterViewController: RegisterDisplayable {

    func show(error: String) {
        let alert = AlertBuilder.shared.buildOkAlert(with: Constants.errorTitle.localized(), message: error, buttonPressHandler: nil)
        present(alert, animated: true, completion: nil)
    }

}

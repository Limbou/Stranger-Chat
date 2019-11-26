//
//  LoginViewController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private enum Constants {
    static let title = "login.title"
}

final class LoginViewController: UIViewController {

    private let interactor: LoginInteractor
    private let bag = DisposeBag()

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: RoundButton!

    init(interactor: LoginInteractor) {
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
    }

    private func setupBindings() {
        loginButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .map({ LoginData(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") })
            .bind(to: interactor.loginObserver)
            .disposed(by: bag)
    }

}

extension LoginViewController: LoginDisplayable {

    func showError(title: String, message: String) {
        let alert = AlertBuilder.shared.buildOkAlert(with: title,
                                                     message: message,
                                                     buttonPressHandler: nil)
        present(alert, animated: true, completion: nil)
    }

}

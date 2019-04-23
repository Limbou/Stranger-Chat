//
//  RegisterViewController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class RegisterViewController: UIViewController {

    private let interactor: RegisterInteractor
    private let bag = DisposeBag()
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var repeatPasswordField: UITextField!
    @IBOutlet var registerButton: UIButton!

    init(interactor: RegisterInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        registerButton.rx.tap
            .throttle(1.0, scheduler: MainScheduler.instance)
            .bind(to: interactor.registerButtonObserver)
            .disposed(by: bag)
    }

}

extension RegisterViewController: RegisterDisplayable {

}

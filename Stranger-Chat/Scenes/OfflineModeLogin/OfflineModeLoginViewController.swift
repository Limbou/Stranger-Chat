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

final class OfflineModeLoginViewController: UIViewController {

    private let interactor: OfflineModeLoginInteractor
    private let bag = DisposeBag()
    @IBOutlet var nameField: UITextField!
    @IBOutlet var offlineModeLoginButton: UIButton!

    init(interactor: OfflineModeLoginInteractor) {
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
        offlineModeLoginButton.rx.tap
            .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(nameField.rx.text)
            .bind(to: interactor.offlineModeLoginButtonObserver)
            .disposed(by: bag)
    }

}

extension OfflineModeLoginViewController: OfflineModeLoginDisplayable {

}

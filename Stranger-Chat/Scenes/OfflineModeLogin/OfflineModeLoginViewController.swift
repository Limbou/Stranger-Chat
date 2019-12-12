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

private enum Constants {
    static let title = "offlineModeLogin.title"
    static let alertTitle = "offlineModeLogin.alert.title"
    static let alertMessage = "offlineModeLogin.alert.message"
}

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
        title = Constants.title.localized()
        setupBindings()
    }

    private func setupBindings() {
        offlineModeLoginButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(nameField.rx.text)
            .bind(to: interactor.offlineModeLoginObserver)
            .disposed(by: bag)
    }

}

extension OfflineModeLoginViewController: OfflineModeLoginDisplayable {

    func showWrongNameAlert() {
        let alert = AlertBuilder.shared.buildOkAlert(with: Constants.alertTitle.localized(),
                                                     message: Constants.alertMessage.localized(),
                                                     buttonPressHandler: nil)
        present(alert, animated: true, completion: nil)
    }

}

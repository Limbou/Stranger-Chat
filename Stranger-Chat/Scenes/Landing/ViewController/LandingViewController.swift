//
//  LandingViewController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LandingViewController: UIViewController {

    private let bag = DisposeBag()
    internal let interactor: LandingInteractor
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!

    init(interactor: LandingInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonsActions()
    }

    private func setupButtonsActions() {
        loginButton.rx.tap
            .throttle(1.0, scheduler: MainScheduler.instance)
            .bind(to: interactor.loginButtonObserver)
            .disposed(by: bag)
        registerButton.rx.tap
            .throttle(1.0, scheduler: MainScheduler.instance)
            .bind(to: interactor.registerButtonObserver)
            .disposed(by: bag)
    }

}

//
//  LandingViewController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import UIKit

private extension Selector {
    static let goToLogin = #selector(LandingViewController.goToLogin)
    static let goToRegister = #selector(LandingViewController.goToRegister)
}

class LandingViewController: UIViewController {

    private let mainView = LandingView()
    private lazy var router: LandingRoutable = LandingRouter(viewController: self)

    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupButtonsActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        view = mainView
        mainView.setup()
    }

    private func setupButtonsActions() {
        mainView.loginButton.addTarget(self, action: .goToLogin, for: .touchUpInside)
        mainView.registerButton.addTarget(self, action: .goToRegister, for: .touchUpInside)
    }

    @objc fileprivate func goToLogin() {
        router.showLoginScene()
    }

    @objc fileprivate func goToRegister() {
        router.showRegisterScene()
    }

}

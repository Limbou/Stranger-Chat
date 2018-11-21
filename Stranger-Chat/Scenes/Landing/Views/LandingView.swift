//
//  LandingView.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import Foundation
import SnapKit
import Localize_Swift

private struct Constants {

    struct TitleLabel {
        static let title = "landing.titleLabel.text"
        struct Constraints {
            let top = 100
            let leading = 100
            let trailing = -100
        }
    }

    struct LoginButton {
        static let title = "landing.loginButton.title"
        struct Constraints {
            let top = 100
            let leading = 100
            let trailing = -100
            let height = 50
        }
    }

    struct RegisterButton {
        static let title = "landing.registerButton.title"
        struct Constraints {
            let top = 50
            let leading = 100
            let trailing = -100
            let height = 50
        }
    }

}

class LandingView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.TitleLabel.title.localized()
        label.textAlignment = .center
        return label
    }()

    let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.green
        button.setTitle(Constants.LoginButton.title.localized(), for: .normal)
        return button
    }()

    let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blue
        button.setTitle(Constants.RegisterButton.title.localized(), for: .normal)
        return button
    }()

    func setup() {
        backgroundColor = UIColor.white
        setupTitleLabel()
        setupLoginButton()
        setupRegisterButton()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            let constraints = Constants.TitleLabel.Constraints()
            make.top.equalTo(constraints.top)
            make.leading.equalTo(constraints.leading)
            make.trailing.equalTo(constraints.trailing)
        }
    }

    private func setupLoginButton() {
        addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            let constraints = Constants.LoginButton.Constraints()
            make.top.equalTo(titleLabel.snp.bottom).offset(constraints.top)
            make.leading.equalTo(constraints.leading)
            make.trailing.equalTo(constraints.trailing)
            make.height.equalTo(constraints.height)
        }
    }

    private func setupRegisterButton() {
        addSubview(registerButton)
        registerButton.snp.makeConstraints { (make) in
            let constraints = Constants.RegisterButton.Constraints()
            make.top.equalTo(loginButton.snp.bottom).offset(constraints.top)
            make.leading.equalTo(constraints.leading)
            make.trailing.equalTo(constraints.trailing)
            make.height.equalTo(constraints.height)
        }
    }

}

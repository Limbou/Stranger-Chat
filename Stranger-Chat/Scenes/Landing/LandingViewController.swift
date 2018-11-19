//
//  LandingViewController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    private let mainView = LandingView()
    private lazy var router: LandingRoutable = LandingRouter(viewController: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view = mainView
        mainView.setup()
    }

}

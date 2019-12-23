//
//  MainNavigationController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 23/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class MainNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        navigationBar.barStyle = .black
        navigationBar.barTintColor = Color.darkBlue
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
    }

}

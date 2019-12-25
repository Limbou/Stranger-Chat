//
//  UIViewController+Extension.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 23/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

extension UIViewController {

    func add(child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)

        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            child.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            child.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

    func presentLoading() {
        let browsing = LoadingViewController.shared
        add(child: browsing)
    }

    func hideLoading() {
        LoadingViewController.shared.hide()
    }

}

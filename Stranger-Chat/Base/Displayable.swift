//
//  Displayable.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 26/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol Displayable: UIViewController {
    func presentLoading()
    func hideLoading()
}

extension Displayable {

    func presentLoading() {
        let loading = LoadingViewController.shared
        add(child: loading)
    }

    func hideLoading() {
        LoadingViewController.shared.hide()
    }

}

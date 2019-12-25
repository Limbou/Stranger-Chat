//
//  Presenter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 25/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol Presenter: AnyObject {
    var viewController: Displayable? { get set }
    func presentLoading()
    func hideLoading()
}

extension Presenter {

    func presentLoading() {
        viewController?.presentLoading()
    }

    func hideLoading() {
        viewController?.hideLoading()
    }

}

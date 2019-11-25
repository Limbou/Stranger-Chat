//
//  RegisterPresenter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol OfflineModeLoginDisplayable: AnyObject {
    func showWrongNameAlert()
}

protocol OfflineModeLoginPresenter: AnyObject {
    var viewController: OfflineModeLoginDisplayable? { get set }
    func showWrongNameAlert()
}

final class OfflineModeLoginPresenterImpl: OfflineModeLoginPresenter {

    weak var viewController: OfflineModeLoginDisplayable?

    func showWrongNameAlert() {
        viewController?.showWrongNameAlert()
    }
}

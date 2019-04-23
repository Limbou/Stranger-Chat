//
//  RegisterPresenter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol OfflineModeLoginDisplayable: AnyObject {

}

protocol OfflineModeLoginPresenter: AnyObject {
    var viewController: OfflineModeLoginDisplayable? { get set }
}

final class OfflineModeLoginPresenterImpl: OfflineModeLoginPresenter {

    weak var viewController: OfflineModeLoginDisplayable?

}

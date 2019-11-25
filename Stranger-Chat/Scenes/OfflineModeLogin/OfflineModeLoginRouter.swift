//
//  RegisterRouter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol OfflineModeLoginRouter: AnyObject {
    var viewController: UIViewController? { get set }
    func showMainScreen()
}

final class OfflineModeLoginRouterImpl: OfflineModeLoginRouter {

    weak var viewController: UIViewController?

    func showMainScreen() {
        print("Poszlo")
    }

}

//
//  AlertBuilder.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 11/06/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

private enum Constants {
    static let alertOk = "alert.button.ok"
}

typealias ButtonPressHandler = ((UIAlertAction) -> Void)?

final class AlertBuilder {

    static let shared = AlertBuilder()

    private init() {}

    func buildOkAlert(with title: String?, message: String?, buttonPressHandler: ButtonPressHandler) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Constants.alertOk.localized(), style: .default, handler: buttonPressHandler)
        alertController.addAction(alertAction)
        return alertController
    }

}

//
//  UIAlertController+Activity.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 23/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

extension UIAlertController {

    private struct ActivityIndicatorData {
        static var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }

    func addActivityIndicator() {
        let viewController = UIViewController()
        viewController.preferredContentSize = CGSize(width: 50, height: 50)
        ActivityIndicatorData.activityIndicator.color = UIColor.black
        ActivityIndicatorData.activityIndicator.startAnimating()
        viewController.view.addSubview(ActivityIndicatorData.activityIndicator)
        self.setValue(viewController, forKey: "contentViewController")
    }
}

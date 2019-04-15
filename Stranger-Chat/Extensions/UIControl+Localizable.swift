//
//  UIControl+Localizable.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import Localize_Swift

protocol XIBLocalizable {
    var localizationKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var localizationKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized()
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable var localizationKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized(), for: .normal)
        }
    }
}

extension UITextField: XIBLocalizable {
    @IBInspectable var localizationKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized()
        }
    }
}

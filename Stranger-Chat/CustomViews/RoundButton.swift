//
//  RoundButton.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 23/04/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

@IBDesignable
final class RoundButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 20 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    override func prepareForInterfaceBuilder() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        super.prepareForInterfaceBuilder()
    }

}

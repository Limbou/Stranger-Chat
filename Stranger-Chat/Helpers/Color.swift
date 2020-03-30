//
//  Color.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 23/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class Color {

    static let darkBlue = color(red: 22, green: 22, blue: 92)
    static let skyGreen = color(red: 54, green: 173, blue: 86)
    static let purple = color(red: 50, green: 17, blue: 92)

    static private func color(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }

}

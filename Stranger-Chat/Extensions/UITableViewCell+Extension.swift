//
//  UITableViewCell+Extension.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 09/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

extension UITableViewCell {

    class var reuseIdentifier: String {
        return String(describing: self)
    }

}

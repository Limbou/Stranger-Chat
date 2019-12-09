//
//  UITableView+Extension.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 09/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

extension UITableView {

    func register<T: UITableViewCell>(_: T.Type) {
        register(UINib(nibName: T.reuseIdentifier, bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeue<T: UITableViewCell>(_: T.Type) -> UITableViewCell? {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier)
    }

}

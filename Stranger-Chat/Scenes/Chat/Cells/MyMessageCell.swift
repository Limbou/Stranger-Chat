//
//  MyMessageCell.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 09/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell {

    @IBOutlet var messageBackground: UIView!
    @IBOutlet var messageLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        messageBackground.layer.cornerRadius = 5
    }

}

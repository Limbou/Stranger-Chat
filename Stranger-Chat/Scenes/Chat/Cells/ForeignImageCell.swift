//
//  ForeignImageCell.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 12/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

class ForeignImageCell: UITableViewCell {

    @IBOutlet var photoView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        photoView.layer.cornerRadius = 5
    }

}

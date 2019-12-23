//
//  StrangerCell.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 23/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

private enum Constants {
    static let isOnline = "strangerBrowser.isOnline.text"
    static let isOffline = "strangerBrowser.isOffline.text"
}

final class StrangerCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet private var isOnlineLabel: UILabel!
    @IBOutlet private var isOnlineView: UIView!
    var isOnline: Bool = false {
        didSet {
            updateOnlineStatus()
        }
    }

    private func updateOnlineStatus() {
        isOnlineLabel.text = isOnline ? Constants.isOnline.localized() : Constants.isOffline.localized()
        isOnlineView.backgroundColor = isOnline ? .green : .red
    }

}

//
//  ConversationCell.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 02/01/2020.
//  Copyright © 2020 Jakub Danielczyk. All rights reserved.
//

import UIKit

private enum Constants {
    static let isOnline = "archive.conversation.isOnline.text"
    static let isOffline = "archive.conversation.isOffline.text"
    static let numberOfMessages = "archive.numberOfMessages.text"
}

final class ConversationCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var isOnlineLabel: UILabel!
    @IBOutlet var isOnlineView: UIView!
    @IBOutlet var numberOfMessagesLabel: UILabel!

    var isOnline: Bool = false {
        didSet {
            updateOnlineStatus()
        }
    }

    var numberOfMessages: Int = 0 {
        didSet {
            numberOfMessagesLabel.text = Constants.numberOfMessages.localized() + "\(numberOfMessages)"
        }
    }

    private func updateOnlineStatus() {
        isOnlineLabel.text = isOnline ? Constants.isOnline.localized() : Constants.isOffline.localized()
        isOnlineView.backgroundColor = isOnline ? .green : .red
    }
    
}

//
//  ChatCellFactory.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 12/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol ChatCellFactory: AnyObject {
    func registerCells(tableView: UITableView)
    func prepareCell(from message: ChatMessage, tableView: UITableView) -> UITableViewCell
}

final class ChatCellFactoryImpl: ChatCellFactory {

    func registerCells(tableView: UITableView) {
        tableView.register(MyMessageCell.self)
        tableView.register(ForeignMessageCell.self)
        tableView.register(MyImageCell.self)
        tableView.register(ForeignImageCell.self)
    }

    func prepareCell(from message: ChatMessage, tableView: UITableView) -> UITableViewCell {
        if message.content != nil {
            return prepareMessageCell(from: message, tableView: tableView)
        } else if message.image != nil {
            return prepareImageCell(from: message, tableView: tableView)
        } else {
            return UITableViewCell()
        }
    }

    private func prepareMessageCell(from message: ChatMessage, tableView: UITableView) -> UITableViewCell {
        if message.isAuthor {
            guard let cell = tableView.dequeue(MyMessageCell.self) as? MyMessageCell else {
                return UITableViewCell()
            }
            cell.messageLabel.text = message.content
            return cell
        } else {
            guard let cell = tableView.dequeue(ForeignMessageCell.self) as? ForeignMessageCell else {
                return UITableViewCell()
            }
            cell.messageLabel.text = message.content
            return cell
        }
    }

    private func prepareImageCell(from message: ChatMessage, tableView: UITableView) -> UITableViewCell {
        if message.isAuthor {
            guard let cell = tableView.dequeue(MyImageCell.self) as? MyImageCell else {
                return UITableViewCell()
            }
            cell.photoView.image = message.image
            return cell
        } else {
            guard let cell = tableView.dequeue(ForeignImageCell.self) as? ForeignImageCell else {
                return UITableViewCell()
            }
            cell.photoView.image = message.image
            return cell
        }
    }

}

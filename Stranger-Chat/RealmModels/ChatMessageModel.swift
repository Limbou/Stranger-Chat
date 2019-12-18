//
//  ChatMessageModel.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 18/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import RealmSwift

@objcMembers
final class ChatMessageModel: Object {

    dynamic var messageId: String?
    dynamic var content: String?
    dynamic var imagePath: String?
    dynamic var isAuthor: Bool = false

    override static func primaryKey() -> String? {
        return "messageId"
    }

}

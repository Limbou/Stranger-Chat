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

    dynamic var senderId: String?
    dynamic var messageId: String?
    dynamic var content: String?
    dynamic var imagePath: String?

    override static func primaryKey() -> String? {
        return "messageId"
    }

}

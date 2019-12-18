//
//  ConversationModel.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 18/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import RealmSwift

@objcMembers
final class ConversationModel: Object {

    dynamic var conversationId: String?
    let messages = List<ChatMessageModel>()

    override static func primaryKey() -> String? {
        return "conversationId"
    }

}

//
//  Conversation.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 13/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class OnlineConversation: Conversation, Codable {

    let conversationId: String
    let conversatorName: String
    var messages: [Message] {
        return onlineMessages
    }
    var onlineMessages: [FirebaseChatMessage]
    var isOnline: Bool = true

    enum CodingKeys: String, CodingKey {
        case conversationId, conversatorName, onlineMessages
    }

    init(conversationId: String, conversatorName: String, messages: [FirebaseChatMessage] = []) {
        self.conversationId = conversationId
        self.conversatorName = conversatorName
        self.onlineMessages = messages
    }

}

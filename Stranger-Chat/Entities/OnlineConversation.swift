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
    var messages: [Message] {
        return onlineMessages
    }
    var onlineMessages: [FirebaseChatMessage]

    enum CodingKeys: String, CodingKey {
        case conversationId, onlineMessages
    }

    init(conversationId: String, messages: [FirebaseChatMessage] = []) {
        self.conversationId = conversationId
        self.onlineMessages = messages
    }

}

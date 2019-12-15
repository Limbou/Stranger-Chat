//
//  Conversation.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 13/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class Conversation: Codable {

    let conversationId: String
    var messages: [FirebaseChatMessage]

    enum CodingKeys: String, CodingKey {
        case conversationId, messages
    }

    init(conversationId: String, messages: [FirebaseChatMessage] = []) {
        self.conversationId = conversationId
        self.messages = messages
    }

}

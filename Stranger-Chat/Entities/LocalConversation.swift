//
//  LocalConversation.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 18/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class LocalConversation: Conversation {

    let conversationId: String
    let conversatorName: String
    var messages: [Message] {
        return localMessages
    }
    var localMessages: [ChatMessage]
    var isOnline: Bool = false

    init(conversationId: String = UUID().uuidString, conversatorName: String, messages: [ChatMessage] = []) {
        self.conversationId = conversationId
        self.conversatorName = conversatorName
        self.localMessages = messages
    }

}

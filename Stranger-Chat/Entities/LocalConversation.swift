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
    var messages: [Message] {
        return localMessages
    }
    var localMessages: [ChatMessage]

    init(conversationId: String = UUID().uuidString, messages: [ChatMessage] = []) {
        self.conversationId = conversationId
        self.localMessages = messages
    }

}

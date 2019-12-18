//
//  LocalConversation.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 18/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class LocalConversation {

    let conversationId: String
    var messages: [ChatMessage]

    init(conversationId: String = UUID().uuidString, messages: [ChatMessage] = []) {
        self.conversationId = conversationId
        self.messages = messages
    }

}

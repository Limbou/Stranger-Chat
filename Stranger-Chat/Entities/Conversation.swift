//
//  Conversation.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 29/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol Conversation: AnyObject {
    var conversationId: String { get }
    var conversatorName: String { get }
    var messages: [Message] { get }
    var isOnline: Bool { get }
}

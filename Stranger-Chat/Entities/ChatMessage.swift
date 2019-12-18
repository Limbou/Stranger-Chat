//
//  Message.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 09/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class ChatMessage {

    let messageId: String
    let content: String?
    let image: UIImage?
    var imagePath: String?
    let isAuthor: Bool

    init(messageId: String, content: String?, image: UIImage?, imagePath: String?, isAuthor: Bool) {
        self.messageId = messageId
        self.content = content
        self.image = image
        self.imagePath = imagePath
        self.isAuthor = isAuthor
    }

    convenience init(content: String?, isAuthor: Bool) {
        self.init(messageId: UUID().uuidString, content: content, image: nil, imagePath: nil, isAuthor: isAuthor)
    }

    convenience init(image: UIImage?, isAuthor: Bool) {
        self.init(messageId: UUID().uuidString, content: nil, image: image, imagePath: nil, isAuthor: isAuthor)
    }
}

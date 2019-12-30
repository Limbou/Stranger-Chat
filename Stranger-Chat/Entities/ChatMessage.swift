//
//  Message.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 09/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class ChatMessage: Message {

    let senderId: String
    let messageId: String
    let content: String?
    let image: UIImage?
    var imagePath: String?

    init(messageId: String,
         senderId: String,
         content: String?,
         image: UIImage?,
         imagePath: String?) {
        self.messageId = messageId
        self.senderId = senderId
        self.content = content
        self.image = image
        self.imagePath = imagePath
    }

    convenience init(content: String?, senderId: String) {
        self.init(messageId: UUID().uuidString,
                  senderId: senderId,
                  content: content,
                  image: nil,
                  imagePath: nil)
    }

    convenience init(image: UIImage?, senderId: String) {
        self.init(messageId: UUID().uuidString,
                  senderId: senderId,
                  content: nil,
                  image: image,
                  imagePath: nil)
    }

    convenience init(content: String?, image: UIImage?, senderId: String) {
        self.init(messageId: UUID().uuidString,
                  senderId: senderId,
                  content: content,
                  image: image,
                  imagePath: nil)
    }

}

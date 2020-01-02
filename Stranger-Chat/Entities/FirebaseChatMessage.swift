//
//  FirebaseChatMessage.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class FirebaseChatMessage: Message, Codable {

    let messageId: String
    let senderId: String
    let content: String?
    let image: UIImage?
    var imagePath: String?

    enum CodingKeys: String, CodingKey {
        case messageId, senderId, content, imagePath
    }

    init(messageId: String, senderId: String, content: String?, image: UIImage?, imagePath: String?) {
        self.messageId = messageId
        self.senderId = senderId
        self.content = content
        self.image = image
        self.imagePath = imagePath
    }

    convenience init(senderId: String, content: String) {
        self.init(messageId: UUID().uuidString, senderId: senderId, content: content, image: nil, imagePath: nil)
    }

    convenience init(senderId: String, image: UIImage?) {
        self.init(messageId: UUID().uuidString, senderId: senderId, content: nil, image: image, imagePath: nil)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        messageId = try container.decode(String.self, forKey: .messageId)
        senderId = try container.decode(String.self, forKey: .senderId)
        content = try container.decodeIfPresent(String.self, forKey: .content)
        imagePath = try container.decodeIfPresent(String.self, forKey: .imagePath)
        image = nil
    }
}

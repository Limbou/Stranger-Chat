//
//  FirebaseChatMessage.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class FirebaseChatMessage: Codable {

    let senderId: String
    let content: String?
    let image: UIImage?
    var imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case senderId, content, imageUrl
    }

    init(senderId: String, content: String?, image: UIImage?, imageUrl: String?) {
        self.senderId = senderId
        self.content = content
        self.image = image
        self.imageUrl = imageUrl
    }

    convenience init(senderId: String, content: String) {
        self.init(senderId: senderId, content: content, image: nil, imageUrl: nil)
    }

    convenience init(senderId: String, image: UIImage) {
        self.init(senderId: senderId, content: nil, image: image, imageUrl: nil)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        senderId = try container.decode(String.self, forKey: .senderId)
        content = try container.decodeIfPresent(String.self, forKey: .content)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        image = nil
    }
}

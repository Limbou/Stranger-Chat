//
//  Message.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 09/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class ChatMessage {
    let content: String?
    let image: UIImage?
    let isAuthor: Bool

    init(content: String?, image: UIImage?, isAuthor: Bool) {
        self.content = content
        self.image = image
        self.isAuthor = isAuthor
    }

    convenience init(content: String, isAuthor: Bool) {
        self.init(content: content, image: nil, isAuthor: isAuthor)
    }

    convenience init(image: UIImage, isAuthor: Bool) {
        self.init(content: nil, image: image, isAuthor: isAuthor)
    }
}

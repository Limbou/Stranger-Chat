//
//  User.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 21/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import FirebaseAuth

final class AppUser: Codable {

    let userId: String
    var name: String
    let chatsIds: [String]

    init(userId: String, name: String, chatsIds: [String] = []) {
        self.userId = userId
        self.name = name
        self.chatsIds = chatsIds
    }

    enum CodingKeys: String, CodingKey {
        case userId, name, chatsIds
    }

    convenience init?(from model: AppUserModel?) {
        guard let model = model,
            let userId = model.userId,
            let name = model.name else {
                return nil
        }
        self.init(userId: userId, name: name)
    }

    convenience init?(from user: User?) {
        guard let user = user, let name = user.displayName else {
            return nil
        }
        self.init(userId: user.uid, name: name)
    }

}

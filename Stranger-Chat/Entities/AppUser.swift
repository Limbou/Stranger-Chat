//
//  User.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 21/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class AppUser {

    let userId: String
    let name: String

    init(userId: String, name: String) {
        self.userId = userId
        self.name = name
    }

    convenience init?(from model: AppUserModel?) {
        guard let model = model,
            let userId = model.userId,
            let name = model.name else {
                return nil
        }
        self.init(userId: userId, name: name)
    }

}

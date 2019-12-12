//
//  User.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 21/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import RealmSwift

@objcMembers
final class AppUserModel: Object {

    dynamic var userId: String?
    dynamic var name: String?

    override static func primaryKey() -> String? {
        return "userId"
    }

}

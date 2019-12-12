//
//  Error+Code.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    var userInfo: [String: Any] { return (self as NSError).userInfo }
}

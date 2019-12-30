//
//  Message.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 29/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol Message: AnyObject {
    var messageId: String { get }
    var senderId: String { get }
    var content: String? { get }
    var image: UIImage? { get }
}

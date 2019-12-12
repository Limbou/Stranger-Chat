//
//  RegisterSerializer.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 28/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol RegisterValidator: AnyObject {

    func validate(_ email: String?, password: String?) -> [ValidationError]

}

final class RegisterValidatorImpl: RegisterValidator {

    func validate(_ email: String?, password: String?) -> [ValidationError] {
        return []
    }

}

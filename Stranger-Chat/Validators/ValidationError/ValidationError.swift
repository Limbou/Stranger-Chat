//
//  ValidationError.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 28/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Foundation

enum ValidationErrorType {
    case tooShort
    case wrongFormat
}

enum ValidatedFieldType {
    case email
    case password
}

struct ValidationError {

    let type: ValidationErrorType
    let field: ValidatedFieldType

}

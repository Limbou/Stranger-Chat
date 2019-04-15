//
//  Optional+NilOrEmpty.swift
//  
//
//  Created by Jakub Danielczyk on 28/02/2019.
//

import UIKit

extension Optional where Wrapped: Collection {

    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }

}

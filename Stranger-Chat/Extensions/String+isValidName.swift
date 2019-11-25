//
//  String+isValidName.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 10/05/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

private struct Constants {
    static let minimumNameLength = 3
}

extension String {

    func isValidName() -> Bool {
        return self.count >= Constants.minimumNameLength
    }

}

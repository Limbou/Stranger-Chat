//
//  RegisterInteractor.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol RegisterInteractable: AnyObject {

}

final class RegisterInteractor: RegisterInteractable {

    private let presenter: RegisterPresentable
    private let router: RegisterRoutable

    init(presenter: RegisterPresentable, router: RegisterRoutable) {
        self.presenter = presenter
        self.router = router
    }

}

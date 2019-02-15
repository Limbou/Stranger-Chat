//
//  InteractorFactory.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Foundation

struct InteractorFactory {

    func getLandingInteractor(router: LandingRoutable) -> LandingInteractable {
        return LandingInteractor(router: router)
    }

    func getRegisterInteractor(presenter: RegisterPresentable, router: RegisterRoutable) -> RegisterInteractable {
        return RegisterInteractor(presenter: presenter, router: router)
    }

}

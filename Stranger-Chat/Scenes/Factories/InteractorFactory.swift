//
//  InteractorFactory.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Foundation

final class InteractorFactory {

    func getLandingInteractor(router: LandingRouter) -> LandingInteractor {
        return LandingInteractorImpl(router: router)
    }

    func getRegisterInteractor(presenter: OfflineModeLoginPresenter, router: OfflineModeLoginRouter) -> OfflineModeLoginInteractor {
        return OfflineModeLoginInteractorImpl(presenter: presenter, router: router)
    }

}

//
//  LandingInteractor.swift
//  
//
//  Created by Jakub Danielczyk on 18/02/2019.
//

@testable import Stranger_Chat

import Quick
import Nimble

final class LandingInteractorSpec: QuickSpec {

    private var interactor: LandingInteractor!

    override func spec() {
        beforeEach {
            let router = RouterFactory().getLandingRouter()
            self.interactor = InteractorFactory().getLandingInteractor(router: router)
        }

    }

}

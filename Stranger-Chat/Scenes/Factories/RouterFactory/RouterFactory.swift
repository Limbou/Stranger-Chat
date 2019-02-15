//
//  RouterFactory.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Foundation

struct RouterFactory {

    func getLandingRouter() -> LandingRoutable {
        return LandingRouter()
    }

    func getRegisterRouter() -> RegisterRoutable {
        return RegisterRouter()
    }

}

//
//  Provider.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 21/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

import Swinject
import SwinjectAutoregistration

final class Provider {

    static let get = Provider()
    private let assembler: Assembler

    private init() {
        assembler = Assembler([ScreenAssembly(),
                               RepositoryAssembly(),
                               ServicesAssembly()])
    }

    func instanceOf<Service>(_ serviceType: Service.Type) -> Service {
        return assembler.resolver.resolve(serviceType)!
    }

}

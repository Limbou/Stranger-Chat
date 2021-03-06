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

    func instanceOf<Service, Argument>(_ serviceType: Service.Type, argument: Argument) -> Service {
        return assembler.resolver.resolve(serviceType, argument: argument)!
    }

    func instanceOf<Service, Argument, Argument2>(_ serviceType: Service.Type, arguments: Argument, _ arg2: Argument2) -> Service {
        return assembler.resolver.resolve(serviceType, arguments: arguments, arg2)!
    }

}

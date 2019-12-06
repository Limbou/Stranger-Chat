//
//  SerializerAssembly.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 21/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

final class ServicesAssembly: Assembly {

    func assemble(container: Container) {

        container.register(LocalStorageProtocol.self) { _ in RealmManager.shared }
        container.register(PeerHostSession.self) { _ in PeerHostSession.shared }
        container.register(PeerClientSession.self) { _ in PeerClientSession.shared }

    }

}

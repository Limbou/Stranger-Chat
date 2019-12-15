//
//  SerializerAssembly.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 21/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Swinject
import SwinjectAutoregistration
import FirebaseFirestore
import CodableFirebase

final class ServicesAssembly: Assembly {

    func assemble(container: Container) {
        container.register(LocalStorageProtocol.self) { _ in RealmManager.shared }
//        container.register(PeerHostSession.self) { _ in PeerHostSession.shared }
//        container.register(PeerClientSession.self) { _ in PeerClientSession.shared }
        container.register(FileManager.self) { _ in FileManager.default }
        container.register(Firestore.self) { _ in Firestore.firestore() }
        container.autoregister(FirebaseEncoder.self, initializer: FirebaseEncoder.init)
        container.autoregister(FirebaseDecoder.self, initializer: FirebaseDecoder.init)

    }

}

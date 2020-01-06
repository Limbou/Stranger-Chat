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
import FirebaseStorage
import FirebaseAuth
import CodableFirebase

final class ServicesAssembly: Assembly {

    func assemble(container: Container) {
        container.register(LocalStorageProtocol.self) { _ in RealmManager.shared }
        container.register(PeerHostSession.self) { _ in PeerHostSession.getInstance() }
        container.register(PeerClientSession.self) { _ in PeerClientSession.getInstance() }
        container.register(FileManager.self) { _ in FileManager.default }
        container.register(Firestore.self) { _ in Firestore.firestore() }
        container.autoregister(FirebaseEncoder.self, initializer: FirebaseEncoder.init)
        container.autoregister(FirebaseDecoder.self, initializer: FirebaseDecoder.init)
        container.register(Storage.self) { _ in Storage.storage() }
        container.register(Auth.self) { _ in Auth.auth() }

    }

}

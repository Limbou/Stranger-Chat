//
//  RepositoryAssembly.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 21/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

final class RepositoryAssembly: Assembly {

    func assemble(container: Container) {

        container.autoregister(FirebaseUsersRepository.self, initializer: FirebaseUsersRepositoryImpl.init)
        container.autoregister(LocalUserRepository.self, initializer: LocalUserRepositoryImpl.init(localStorage:))
        container.autoregister(CurrentUserRepository.self, initializer: CurrentUserRepositoryImpl.init(firebaseUsersRepository:localUsersRepository:))
        container.autoregister(FirestoreUsersRepository.self, initializer: FirestoreUsersRepositoryImpl.init(firestore:))
        container.autoregister(FirestoreChatRepository.self, initializer: FirestoreChatRepositoryImpl.init(firestore:storage:decoder:encoder:))
        
    }

}

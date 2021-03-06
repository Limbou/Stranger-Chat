//
//  CurrentUserRepository.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol CurrentUserRepository: AnyObject {
    func currentUser() -> AppUser?
    func isOnline() -> Bool
    func logout()
}

final class CurrentUserRepositoryImpl: CurrentUserRepository {

    private let firebaseUsersRepository: FirebaseUsersRepository
    private let localUsersRepository: LocalUserRepository

    init(firebaseUsersRepository: FirebaseUsersRepository, localUsersRepository: LocalUserRepository) {
        self.firebaseUsersRepository = firebaseUsersRepository
        self.localUsersRepository = localUsersRepository
    }

    func currentUser() -> AppUser? {
        if let user = firebaseUsersRepository.currentUser(), user.isEmailVerified {
            return AppUser(from: user)
        } else if let localUser = localUsersRepository.getUser() {
            return localUser
        }
        return nil
    }

    func isOnline() -> Bool {
        return firebaseUsersRepository.currentUser() != nil
    }

    func logout() {
        localUsersRepository.logout()
        if isOnline() {
            firebaseUsersRepository.logout()
        }
    }

}

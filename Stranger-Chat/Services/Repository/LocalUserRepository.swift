//
//  UserRepository.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol LocalUserRepository: AnyObject {
    func saveUser(name: String)
    func getUser() -> AppUser?
    func logout()
}

final class LocalUserRepositoryImpl: LocalUserRepository {

    private let localStorage: LocalStorageProtocol

    init(localStorage: LocalStorageProtocol) {
        self.localStorage = localStorage
    }

    func saveUser(name: String) {
        localStorage.deleteAllObjects(type: AppUserModel.self)
        let user = AppUserModel()
        user.userId = UUID().uuidString
        user.name = name
        localStorage.addObject(user)
    }

    func getUser() -> AppUser? {
        let model = localStorage.getObjects(type: AppUserModel.self)?.first
        return AppUser(from: model)
    }

    func logout() {
        localStorage.clear()
    }

}

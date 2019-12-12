//
//  LoginWorker.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol LoginWorker: AnyObject {
    func login(with data: LoginData) -> Observable<Bool>
}

final class LoginWorkerImpl: LoginWorker {

    private let usersRepository: FirebaseUsersRepository

    init(usersRepository: FirebaseUsersRepository) {
        self.usersRepository = usersRepository
    }

    func login(with data: LoginData) -> Observable<Bool> {
        return usersRepository.login(with: data.email, password: data.password)
            .map { $0 != nil }
    }

}

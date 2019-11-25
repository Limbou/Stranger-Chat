//
//  RegisterWorker.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation
import RxSwift

protocol RegisterWorker: AnyObject {
    func register(with data: RegisterData) -> Observable<Bool>
}

final class RegisterWorkerImpl: RegisterWorker {

    private let usersRepository: FirebaseUsersRepository

    init(usersRepository: FirebaseUsersRepository) {
        self.usersRepository = usersRepository
    }

    func register(with data: RegisterData) -> Observable<Bool> {
        return usersRepository.register(with: data.email, password: data.password)
            .map { $0 != nil }
    }

}

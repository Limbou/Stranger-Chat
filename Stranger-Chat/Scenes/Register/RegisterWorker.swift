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
import FirebaseAuth

protocol RegisterWorker: AnyObject {
    func register(with data: RegisterData) -> Observable<Bool>
}

final class RegisterWorkerImpl: RegisterWorker {

    private let usersRepository: FirebaseUsersRepository
    private let firestoreUsersRepository: FirestoreUsersRepository

    init(usersRepository: FirebaseUsersRepository, firestoreUsersRepository: FirestoreUsersRepository) {
        self.usersRepository = usersRepository
        self.firestoreUsersRepository = firestoreUsersRepository
    }

    func register(with data: RegisterData) -> Observable<Bool> {
        usersRepository.register(with: data.email, password: data.password, displayName: data.displayName)
            .flatMap({ user in
                return self.saveUserInFirestore(user: user)
            })
    }

    private func saveUserInFirestore(user: AppUser?) -> Observable<Bool> {
        guard let user = user else {
            return Observable.just(false)
        }
        return firestoreUsersRepository.setUserData(appUser: user)
    }

}

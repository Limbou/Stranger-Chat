//
//  FirebaseUsersRepository.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 21/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import FirebaseAuth
import RxSwift

protocol FirebaseUsersRepository: AnyObject {
    func login(with email: String, password: String) -> Observable<User?>
    func register(with email: String, password: String) -> Observable<User?>
}

final class FirebaseUsersRepositoryImpl: FirebaseUsersRepository {

    func login(with email: String, password: String) -> Observable<User?> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    observer.onError(error)
                }
                observer.onNext(result?.user)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func register(with email: String, password: String) -> Observable<User?> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    observer.onError(error)
                }
                observer.onNext(result?.user)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

}

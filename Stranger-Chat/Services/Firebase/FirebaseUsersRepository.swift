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
    func currentUser() -> User?
    func login(with email: String, password: String) -> Observable<AppUser?>
    func register(with email: String, password: String, displayName: String) -> Observable<AppUser?>
    func logout()
}

final class EmailUnverifiedError: Error {
    var localizedDescription: String {
        return "error.emailUnverified".localized()
    }
}

final class FirebaseUsersRepositoryImpl: FirebaseUsersRepository {

    func currentUser() -> User? {
        return Auth.auth().currentUser
    }

    func login(with email: String, password: String) -> Observable<AppUser?> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    observer.onError(error)
                }
                guard let user = result?.user, user.isEmailVerified else {
                    observer.onError(EmailUnverifiedError())
                    self.logout()
                    return
                }
                observer.onNext(AppUser(from: result?.user))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func register(with email: String, password: String, displayName: String) -> Observable<AppUser?> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    observer.onError(error)
                }
                self.updateDisplayName(user: result?.user, displayName: displayName, observer: observer)
            }
            return Disposables.create()
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func updateDisplayName(user: User?, displayName: String, observer: AnyObserver<AppUser?>) {
        guard let user = user else {
            observer.onNext(nil)
            observer.onCompleted()
            return
        }
        let profileChangeRequest = user.createProfileChangeRequest()
        profileChangeRequest.displayName = displayName
        profileChangeRequest.commitChanges { error in
            if let error = error {
                observer.onError(error)
            }
            user.sendEmailVerification(completion: nil)
            observer.onNext(AppUser(from: user))
            observer.onCompleted()
        }
    }

}

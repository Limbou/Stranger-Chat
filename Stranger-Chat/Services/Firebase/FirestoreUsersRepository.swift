//
//  FirestoreUsersRepository.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 12/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import FirebaseFirestore
import RxSwift
import CodableFirebase

extension DocumentReference: DocumentReferenceType {}

private enum Keys {
    static let users = "users"
}

protocol FirestoreUsersRepository: AnyObject {
    func getData(for userId: String) -> Observable<AppUser?>
    func setUserData(appUser: AppUser) -> Observable<Bool>
}

final class FirestoreUsersRepositoryImpl: FirestoreUsersRepository {

    private let firestore: Firestore
    private let usersRef: CollectionReference
    private let decoder = FirebaseDecoder()
    private let encoder = FirebaseEncoder()

    init(firestore: Firestore) {
        self.firestore = firestore
        usersRef = firestore.collection(Keys.users)
    }

    func getData(for userId: String) -> Observable<AppUser?> {
        let documentRef = usersRef.document(userId)
        return Observable.create { observable in
            documentRef.addSnapshotListener { (documentSnapshot, error) in
                self.handleNewUserData(snapshot: documentSnapshot, error: error, observable: observable)
            }
            return Disposables.create()
        }
    }

    func setUserData(appUser: AppUser) -> Observable<Bool> {
        Observable.create { observable in
            self.tryToSetUser(user: appUser, observable: observable)
            return Disposables.create()
        }
    }

    private func handleNewUserData(snapshot: DocumentSnapshot?, error: Error?, observable: AnyObserver<AppUser?>) {
        if let error = error {
            print("Error fetching document: \(error)")
            observable.onError(error)
            return
        }
        guard let document = snapshot,
            let data = document.data() else {
                print("Document data was empty.")
                observable.onNext(nil)
                observable.onCompleted()
                return
        }
        do {
            let user = try self.decoder.decode(AppUser.self, from: data)
            observable.onNext(user)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func tryToSetUser(user: AppUser, observable: AnyObserver<Bool>) {
        guard let data = getUserData(user: user) else {
            observable.onNext(false)
            observable.onCompleted()
            return
        }
        usersRef.document(user.userId).setData(data) { error in
            if let error = error {
                observable.onError(error)
            }
            observable.onNext(true)
            observable.onCompleted()
        }
    }

    private func getUserData(user: AppUser) -> [String: Any]? {
        do {
            return try encoder.encode(user) as? [String: Any]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}

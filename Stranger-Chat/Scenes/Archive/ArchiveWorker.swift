//
//  ArchiveWorker.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 29/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation
import RxSwift

protocol ArchiveWorker: AnyObject {
    func getPastConversations() -> Observable<[Conversation]>
}

final class ArchiveWorkerImpl: ArchiveWorker {

    private let firestoreUsersRepository: FirestoreUsersRepository
    private let currentUserRepository: CurrentUserRepository
    private let localConversationRepository: LocalConversationRepository
    private let firestoreConversationRepository: FirestoreChatRepository

    private var userDataSubscription: Disposable?

    init(firestoreUsersRepository: FirestoreUsersRepository,
         currentUserRepository: CurrentUserRepository,
         localConversationRepository: LocalConversationRepository,
         firestoreConversationRepository: FirestoreChatRepository) {
        self.firestoreUsersRepository = firestoreUsersRepository
        self.currentUserRepository = currentUserRepository
        self.localConversationRepository = localConversationRepository
        self.firestoreConversationRepository = firestoreConversationRepository
    }

    deinit {
        userDataSubscription?.dispose()
    }

    func getPastConversations() -> Observable<[Conversation]> {
        guard let user = currentUserRepository.currentUser() else {
            print("No user")
            return Observable.just([])
        }
        if currentUserRepository.isOnline() {
            return firestoreUsersRepository.getData(for: user.userId)
                .flatMap { self.getAllPastConversations(user: $0) }
        }
        return getLocalPastConversations(user: user).asObservable()

    }

    private func getAllPastConversations(user: AppUser?) -> Observable<[Conversation]> {
        guard let conversationsId = user?.chatsIds else {
            return Observable.just([])
        }
        return Observable.zip(Observable.just(self.localConversationRepository.getConversations()),
                              firestoreConversationRepository.getConversations(for: conversationsId)) { (localConversations: [LocalConversation], onlineConversations: [OnlineConversation?]) -> [Conversation] in
            let onlineNonOptional = onlineConversations.compactMap { $0 }
            return localConversations + onlineNonOptional
        }
    }

    private func getLocalPastConversations(user: AppUser) -> Single<[Conversation]> {
        return Single.create { single in
            let conversations = self.localConversationRepository.getConversations()
            single(.success(conversations))
            return Disposables.create()
        }
    }

}

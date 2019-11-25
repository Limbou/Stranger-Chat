//
//  OfflineModeLoginWorker.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 25/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol OfflineModeLoginWorker: AnyObject {
    func saveUser(name: String)
}

final class OfflineModeLoginWorkerImpl: OfflineModeLoginWorker {

    private let localUserRepository: LocalUserRepository

    init(localUserRepository: LocalUserRepository) {
        self.localUserRepository = localUserRepository
    }

    func saveUser(name: String) {
        localUserRepository.saveUser(name: name)
    }

}

//
//  StrangersBrowserWorker.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation
import RxSwift

protocol StrangersBrowserWorker: AnyObject {

}

final class StrangersBrowserWorkerImpl: StrangersBrowserWorker {

    private let currentUserRepository: CurrentUserRepository

    init(currentUserRepository: CurrentUserRepository) {
        self.currentUserRepository = currentUserRepository
    }

}

//
//  RegisterWorker.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 28/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol RegisterWorker: AnyObject {
    func register(with email: String, password: String)
}

final class RegisterWorkerImpl: RegisterWorker {

    private let serializer: RegisterSerializer

    init(serializer: RegisterSerializer) {
        self.serializer = serializer
    }

    func register(with email: String, password: String) {

    }

}

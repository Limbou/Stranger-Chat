//
//  RegisterWorker.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 28/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol OfflineModeLoginWorker: AnyObject {
    var nicknameValidationObserver: PublishSubject<String?> { get }
}

final class OfflineModeLoginWorkerImpl: OfflineModeLoginWorker {

    private let serializer: OfflineModeLoginSerializer

    let nicknameValidationObserver = PublishSubject<String?>()

    init(serializer: OfflineModeLoginSerializer) {
        self.serializer = serializer
    }

}

//
//  FirebaseChatWorker.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 12/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

final class FirebaseChatWorker: ChatWorker {

    let receivedMessages = PublishSubject<ChatMessage>()
    let disconnected = PublishSubject<Void>()

    func send(message: String) {
        
    }

    func send(image: UIImage) {

    }

    func disconnectFromSession() {

    }

}

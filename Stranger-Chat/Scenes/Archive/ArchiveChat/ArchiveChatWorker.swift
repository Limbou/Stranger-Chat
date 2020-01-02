//
//  ArchiveWorker.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 02/01/2020.
//  Copyright © 2020 Jakub Danielczyk. All rights reserved.
//

import Foundation
import RxSwift

protocol ArchiveChatWorker: AnyObject {
    func prepare(messages: [Message]) -> Observable<[Message]>
}

final class ArchiveChatWorkerImpl: ArchiveChatWorker {

    private let chatRepository: FirestoreChatRepository

    init(chatRepository: FirestoreChatRepository) {
        self.chatRepository = chatRepository
    }

    func prepare(messages: [Message]) -> Observable<[Message]> {
        return Observable.combineLatest(messages.map({ self.prepare(message: $0) }))
    }

    private func prepare(message: Message) -> Observable<Message> {
        guard let imagePath = message.imagePath else {
            return Observable.just(message)
        }
        if let localMessage = message as? ChatMessage {
            let image = tryToGetImageFrom(url: URL(fileURLWithPath: localMessage.imagePath ?? ""))
            return Observable.just(ChatMessage(image: image, senderId: localMessage.senderId))
        } else if let onlineMessage = message as? FirebaseChatMessage {
            return chatRepository.getImage(for: imagePath).map { image in
                return FirebaseChatMessage(senderId: onlineMessage.senderId, image: image)
            }
        }
        return Observable.just(message)
    }

    private func tryToGetImageFrom(url: URL?) -> UIImage? {
        guard let url = url else {
            return nil
        }
        do {
            let localData = try Data(contentsOf: url)
            guard let image = UIImage(data: localData) else {
                print("Error geting image from data")
                return nil
            }
            return image
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}

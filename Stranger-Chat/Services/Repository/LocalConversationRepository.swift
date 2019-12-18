//
//  LocalConversationRepository.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 18/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

protocol LocalConversationRepository: AnyObject {
    func save(conversation: LocalConversation)
    func getConversations(for ids: [String]) -> [LocalConversation]
}

final class LocalConversationRepositoryImpl: LocalConversationRepository {

    private let localStorage: LocalStorageProtocol
    private let fileManager: FileManager

    init(localStorage: LocalStorageProtocol, fileManager: FileManager) {
        self.localStorage = localStorage
        self.fileManager = fileManager
    }

    func save(conversation: LocalConversation) {
        let model = ConversationModel()
        model.conversationId = conversation.conversationId
        let messagesModels = conversation.messages.map { getChatMessageModel(from: $0) }
        model.messages.append(objectsIn: messagesModels)

        localStorage.addObject(model)
    }

    func getConversations(for ids: [String]) -> [LocalConversation] {
        return ids.compactMap { getConversation(for: $0) }
    }

    private func getConversation(for id: String) -> LocalConversation? {
        guard let conversationModel = localStorage.getObject(type: ConversationModel.self, objectId: id),
            let conversationId = conversationModel.conversationId else {
                return nil
        }
        let messages: [ChatMessage] = conversationModel.messages.compactMap({ self.getChatMessage(from: $0) })
        return LocalConversation(conversationId: conversationId, messages: messages)
    }

    private func getChatMessageModel(from message: ChatMessage) -> ChatMessageModel {
        let model = ChatMessageModel()
        model.messageId = message.messageId
        model.content = message.content
        model.imagePath = message.imagePath
        model.isAuthor = message.isAuthor
        return model
    }

    private func getChatMessage(from model: ChatMessageModel) -> ChatMessage? {
        guard let messageId = model.messageId else {
            return nil
        }
        let image = loadImage(from: model.imagePath)
        return ChatMessage(messageId: messageId, content: model.content, image: image, imagePath: model.imagePath, isAuthor: model.isAuthor)
    }

    private func loadImage(from path: String?) -> UIImage? {
        guard let path = path, let image = UIImage(contentsOfFile: path) else {
            return nil
        }
        return image
    }

    private func getDocumentsDirectory(name: String) -> URL? {
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent(name)
            return fileUrl
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}

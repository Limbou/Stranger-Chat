//
//  WorkerFactory.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 14/03/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class WorkerFactory {

    let networkingFactory = NetworkingFactory()
    let serializerFactory = SerializerFactory()

    func getRegisterWorker() -> OfflineModeLoginWorker {
        let serializer = serializerFactory.getRegisterSerializer()
        return OfflineModeLoginWorkerImpl(serializer: serializer)
    }

}

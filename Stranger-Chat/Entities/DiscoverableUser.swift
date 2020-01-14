//
//  DiscoverableUser.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 17/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Foundation
import MultipeerConnectivity

final class DiscoverableUser {

    let peer: MCPeerID
    let discoveryInfo: [String: String]?

    init(peer: MCPeerID, discoveryInfo: [String: String]? = nil) {
        self.peer = peer
        self.discoveryInfo = discoveryInfo
    }

}

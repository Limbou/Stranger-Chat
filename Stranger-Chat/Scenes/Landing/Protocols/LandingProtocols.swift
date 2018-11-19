//
//  LandingProtocols.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import Foundation

protocol LandingRoutable: Router {
    func showLoginScene()
    func showRegisterScene()
}

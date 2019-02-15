//
//  PresenterFactory.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import Foundation

struct PresenterFactory {

    func getRegisterPresenter() -> RegisterPresentable {
        return RegisterPresenter()
    }

}

//
//  StrangersBrowserPresenter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation

protocol StrangersBrowserDisplayable: AnyObject {

}

protocol StrangersBrowserPresenter: AnyObject {
    var viewController: StrangersBrowserDisplayable? { get set }
}

final class StrangersBrowserPresenterImpl: StrangersBrowserPresenter {

    weak var viewController: StrangersBrowserDisplayable?

}

//
//  HomePresenter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import Foundation

protocol HomeDisplayable: AnyObject {

}

protocol HomePresenter: AnyObject {
    var viewController: HomeDisplayable? { get set }
}

final class HomePresenterImpl: HomePresenter {

    weak var viewController: HomeDisplayable?

}

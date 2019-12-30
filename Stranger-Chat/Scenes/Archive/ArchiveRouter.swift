//
//  ArchiveRouter.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 29/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import UIKit

protocol ArchiveRouter: AnyObject {
    var viewController: UIViewController? { get set }
}

final class ArchiveRouterImpl: ArchiveRouter {

    weak var viewController: UIViewController?

}

//
//  RegisterRouter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol OfflineModeLoginRouter: Router {
    var offlineModeLoginObserver: AnyObserver<Void> { get }
}

final class OfflineModeLoginRouterImpl: OfflineModeLoginRouter {

    private let bag = DisposeBag()
    private let offlineModeLoginSubject = PublishSubject<Void>()
    var offlineModeLoginObserver: AnyObserver<Void> {
        return offlineModeLoginSubject.asObserver()
    }
    var viewController: UIViewController?

    init() {
        setupBindings()
    }

    private func setupBindings() {
        offlineModeLoginSubject.subscribe { _ in
            self.goToMainView()
        }.disposed(by: bag)
    }

    private func goToMainView() {

    }

}

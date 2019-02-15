//
//  RegisterRouter.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol RegisterRoutable: Router {
    var loginObserver: AnyObserver<Void> { get }
}

final class RegisterRouter: RegisterRoutable {

    private let bag = DisposeBag()
    private let loginSubject = PublishSubject<Void>()
    var loginObserver: AnyObserver<Void> {
        return loginSubject.asObserver()
    }
    var viewController: UIViewController?

    init() {
        setupBindings()
    }

    private func setupBindings() {
        loginSubject.subscribe { _ in
            self.goToMainView()
        }.disposed(by: bag)
    }

    private func goToMainView() {

    }

}

//
//  RegisterInteractor.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 15/02/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol OfflineModeLoginInteractor: AnyObject {
    var offlineModeLoginButtonObserver: AnyObserver<String?> { get }
}

final class OfflineModeLoginInteractorImpl: OfflineModeLoginInteractor {

    private let presenter: OfflineModeLoginPresenter
    private let router: OfflineModeLoginRouter
    
    private let bag = DisposeBag()
    private let offlineModeLoginSubject = PublishSubject<String?>()
    var offlineModeLoginButtonObserver: AnyObserver<String?> {
        return offlineModeLoginSubject.asObserver()
    }

    init(presenter: OfflineModeLoginPresenter, router: OfflineModeLoginRouter) {
        self.presenter = presenter
        self.router = router
        setupBindings()
    }

    private func setupBindings() {
        offlineModeLoginSubject.subscribe { email in
            print(email)
        }.disposed(by: bag)
    }

}

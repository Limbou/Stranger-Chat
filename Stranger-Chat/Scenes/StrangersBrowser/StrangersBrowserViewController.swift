//
//  StrangersBrowserViewController.swift
//  Stranger-Chat
//
//  Created Jakub Danielczyk on 26/11/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//
//
//

import UIKit
import RxSwift
import RxCocoa

private enum Constants {

}

final class StrangersBrowserViewController: UIViewController {

    private let interactor: StrangersBrowserInteractor
    private let bag = DisposeBag()

    init(interactor: StrangersBrowserInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.onWillAppear.onNext(())
    }

    private func setupBindings() {

    }

}

extension StrangersBrowserViewController: StrangersBrowserDisplayable {

}

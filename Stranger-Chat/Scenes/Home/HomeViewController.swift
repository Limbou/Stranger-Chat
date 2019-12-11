//
//  HomeViewController.swift
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
    static let gotInvitation = "invitation.title"
    static let invitationFrom = "invitation.from"
}

final class HomeViewController: UIViewController {

    private let interactor: HomeInteractor
    private let bag = DisposeBag()
    @IBOutlet var findButton: RoundButton!
    @IBOutlet var makeVisibleButton: RoundButton!

    init(interactor: HomeInteractor) {
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

    private func setupBindings() {
        findButton.rx.tap
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .bind(to: interactor.findPressed)
        .disposed(by: bag)

        makeVisibleButton.rx.tap
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .bind(to: interactor.makeVisiblePressed)
        .disposed(by: bag)
    }

}

extension HomeViewController: HomeDisplayable {

    func setAdvertisingButton(advertising: Bool) {
        makeVisibleButton.setTitle(advertising ? "Hide" : "Make visible", for: .normal)
    }

    func presentInvitation(from sender: String, additionalInfo: String?) {
        let alert = AlertBuilder.shared.buildYesNoAlert(with: Constants.gotInvitation.localized(),
                                                        message: Constants.invitationFrom.localized(),
                                                        yesHandler: { _ in
                                                            self.interactor.invitationAccepted.onNext(true)
        }) { _ in
            self.interactor.invitationAccepted.onNext(false)
        }
        present(alert, animated: true, completion: nil)
    }

}

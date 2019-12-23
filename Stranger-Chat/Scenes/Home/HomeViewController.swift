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
    static let gotInvitation = "home.invitation.title"
    static let invitationFrom = "home.invitation.from"
    static let makeVisible = "home.makeVisibleButton.title"
    static let makeVisibleDescription = "home.makeVisible.description.text"
    static let hideDescription = "home.makeInvisible.description.text"
    static let hide = "home.makeInvisibleButton.title"
}

final class HomeViewController: UIViewController {

    private let interactor: HomeInteractor
    private let bag = DisposeBag()
    @IBOutlet var findButton: RoundButton!
    @IBOutlet var makeVisibleButton: RoundButton!
    @IBOutlet var makeVisibleLabel: UILabel!

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
        makeVisibleButton.setTitle(advertising ? Constants.hide.localized() : Constants.makeVisible.localized(), for: .normal)
        makeVisibleButton.backgroundColor = advertising ? UIColor.clear : Color.skyGreen
        makeVisibleLabel.text = advertising ? Constants.hideDescription.localized() : Constants.makeVisibleDescription.localized()
    }

    func presentInvitation(from sender: String, additionalInfo: String?) {
        let alert = AlertBuilder.shared.buildYesNoAlert(with: Constants.gotInvitation.localized(),
                                                        message: Constants.invitationFrom.localized() + sender,
                                                        yesHandler: { _ in
                                                            self.interactor.invitationAccepted.onNext(true)
        }) { _ in
            self.interactor.invitationAccepted.onNext(false)
        }
        present(alert, animated: true, completion: nil)
    }

}

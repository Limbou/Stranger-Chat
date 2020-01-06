//
//  LandingViewController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

private enum Constants {
    static let title = "landing.title"
}

final class LandingViewController: UIViewController {

    private let bag = DisposeBag()
    internal let interactor: LandingInteractor
    @IBOutlet var loginButton: RoundButton!
    @IBOutlet var registerButton: RoundButton!
    @IBOutlet var offlineModeButton: RoundButton!
    @IBOutlet var animationView: AnimationView!

    init(interactor: LandingInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title.localized()
        setupButtonsActions()
        setupAnimation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.pause()
    }

    private func setupButtonsActions() {
        loginButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: interactor.loginPressed)
            .disposed(by: bag)
        registerButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: interactor.registerPressed)
            .disposed(by: bag)
        offlineModeButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: interactor.offlineModePressed)
            .disposed(by: bag)
    }

    private func setupAnimation() {
        let animation = Animation.named("home")
        animationView.animation = animation
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
    }

}

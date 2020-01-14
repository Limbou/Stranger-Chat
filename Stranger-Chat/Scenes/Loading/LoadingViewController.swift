//
//  LoadingViewController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 25/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import Lottie

final class LoadingViewController: UIViewController {

    @IBOutlet var loadingView: AnimationView!

    static let shared = LoadingViewController()

    private init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let animation = Animation.named("loading")
        loadingView.animation = animation
        loadingView.loopMode = .loop
        loadingView.backgroundBehavior = .pauseAndRestore
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingView.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadingView.stop()
    }

    func hide() {
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 0
        }) { _ in
            self.remove()
            self.view.alpha = 1
        }
    }

}

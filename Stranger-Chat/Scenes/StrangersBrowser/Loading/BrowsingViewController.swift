//
//  BrowsingViewController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 23/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit
import Lottie

final class BrowsingViewController: UIViewController {

    @IBOutlet var animationView: AnimationView!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let animation = Animation.named("antenna")
        animationView.animation = animation
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        animationView.play()
    }

    func hide() {
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 0
        }) { _ in
            self.remove()
        }
    }

}

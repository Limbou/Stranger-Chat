//
//  BrowsingViewController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 23/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

private enum Constants {
    static let numberOfPulses = 3
}

final class BrowsingViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    private var pulsesCount = 0
    private var timer: Timer?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = false
        startPulsing()
    }

    func hide() {
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 0
        }) { _ in
            self.remove()
        }
    }

    private func startPulsing() {
        createPulse()
        pulsesCount += 1
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
            guard self.pulsesCount < Constants.numberOfPulses else {
                self.timer?.invalidate()
                return
            }
            self.createPulse()
            self.pulsesCount += 1
        }
    }

    private func createPulse() {
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: UIScreen.main.bounds.size.width / 2,
                                        startAngle: 0,
                                        endAngle: 2 * .pi,
                                        clockwise: true)
        let pulseLayer = CAShapeLayer()
        pulseLayer.path = circularPath.cgPath
        pulseLayer.lineWidth = 6.0
        pulseLayer.fillColor = UIColor.clear.cgColor
        pulseLayer.strokeColor = Color.skyGreen.cgColor
        pulseLayer.lineCap = .round
        let position = imageView.frame.size.width / 2
        pulseLayer.position = CGPoint(x: position, y: position)
        imageView.layer.addSublayer(pulseLayer)
        animate(pulse: pulseLayer)
    }

    private func animate(pulse: CAShapeLayer) {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 0.9
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulse.add(scaleAnimation, forKey: "scale")

        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 2
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulse.add(opacityAnimation, forKey: "opacity")
    }

}

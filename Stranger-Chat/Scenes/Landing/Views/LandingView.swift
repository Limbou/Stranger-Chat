//
//  LandingView.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 19/11/2018.
//  Copyright © 2018 Jakub Danielczyk. All rights reserved.
//

import Foundation
import SnapKit

private struct Constants {

    struct TitleLabel {
        static let title = "WELCOME"
        struct Constraints {
            let top = 200
            let leading = 100
            let trailing = -100
        }
    }

}

class LandingView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.TitleLabel.title
        label.textAlignment = .center
        return label
    }()

    func setup() {
        backgroundColor = UIColor.red
        setupTitleLabel()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            let constraints = Constants.TitleLabel.Constraints()
            make.top.equalToSuperview().offset(constraints.top)
            make.leading.equalToSuperview().offset(constraints.leading)
            make.trailing.equalToSuperview().offset(constraints.trailing)
        }
    }

}

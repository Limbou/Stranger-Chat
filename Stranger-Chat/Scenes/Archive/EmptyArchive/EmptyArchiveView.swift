//
//  EmptyArchiveView.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 06/01/2020.
//  Copyright © 2020 Jakub Danielczyk. All rights reserved.
//

import UIKit

private enum Constants {
    static let nibName = "EmptyArchiveView"
}

final class EmptyArchiveView: UIView {

    @IBOutlet var contentView: UIView!

    override init(frame: CGRect) {
           super.init(frame: frame)
           loadNib()
       }

       required init?(coder: NSCoder) {
           super.init(coder: coder)
           loadNib()
       }

       private func loadNib() {
           Bundle.main.loadNibNamed(Constants.nibName, owner: self, options: nil)
           addSubview(contentView)
           contentView.frame = self.bounds
           contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
       }

}

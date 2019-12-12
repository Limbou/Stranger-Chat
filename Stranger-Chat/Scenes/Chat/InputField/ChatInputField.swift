//
//  ChatInputField.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 08/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

private enum Constants {
    static let nibName = "ChatInputField"
}

final class ChatInputField: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var imageButton: UIButton!
    @IBOutlet var inputField: UITextView!
    @IBOutlet var sendButton: UIButton!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
        setup()
    }

    private func loadNib() {
        Bundle.main.loadNibNamed(Constants.nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func setup() {
        inputField.layer.masksToBounds = true
        inputField.layer.cornerRadius = 10
        inputField.layer.borderWidth = 1
        inputField.layer.borderColor = UIColor.red.cgColor
    }

}

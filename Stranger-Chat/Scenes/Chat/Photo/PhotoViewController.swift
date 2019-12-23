//
//  PhotoViewController.swift
//  Stranger-Chat
//
//  Created by Jakub Danielczyk on 23/12/2019.
//  Copyright © 2019 Jakub Danielczyk. All rights reserved.
//

import UIKit

final class PhotoViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var photoImageView: UIImageView!
    private let photo: UIImage

    init(photo: UIImage) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        photoImageView.image = photo
    }

    private func setupScrollView() {
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
        scrollView.delegate = self
    }

}

extension PhotoViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }

}

//
//  CarPlateRecognitionContainerViewController.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 25.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import UIKit

class CarPlateRecognitionContainerViewController: UIViewController {

    var recognitionViewController: UIViewController!
    var detailInfoViewController: UIViewController!

    @IBOutlet weak var recognitionContainer: UIView! {
        didSet {
            addChild(recognitionViewController)
            recognitionViewController.view.frame = recognitionContainer.bounds
            recognitionContainer.addSubview(recognitionViewController.view)
            recognitionViewController.didMove(toParent: self)
        }
    }
    @IBOutlet weak var detailInfoContainer: UIView! {
        didSet {
            addChild(detailInfoViewController)
            detailInfoViewController.view.translatesAutoresizingMaskIntoConstraints = false
            detailInfoViewController.view.frame = detailInfoContainer.bounds
            detailInfoContainer.addSubview(detailInfoViewController.view)
            detailInfoViewController.didMove(toParent: self)

            let topConstraint = NSLayoutConstraint(item: detailInfoViewController.view, attribute: .top, relatedBy: .equal, toItem: detailInfoContainer, attribute: .top, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: detailInfoViewController.view, attribute: .bottom, relatedBy: .equal, toItem: detailInfoContainer, attribute: .bottom, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: detailInfoViewController.view, attribute: .trailing, relatedBy: .equal, toItem: detailInfoContainer, attribute: .trailing, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: detailInfoViewController.view, attribute: .leading, relatedBy: .equal, toItem: detailInfoContainer, attribute: .leading, multiplier: 1, constant: 0)
            detailInfoContainer.addConstraints([topConstraint, bottomConstraint, leadingConstraint,trailingConstraint])
        }
    }
}

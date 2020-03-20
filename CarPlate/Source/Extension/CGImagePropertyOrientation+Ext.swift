//
//  CGImagePropertyOrientation.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 20.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import UIKit

extension CGImagePropertyOrientation {
    init(_ uiImageOrientation: UIImage.Orientation) {
        switch uiImageOrientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError()
        }
    }
}

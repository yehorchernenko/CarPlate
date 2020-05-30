//
//  GlobalConstants.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 28.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import UIKit

enum Assets {
    static let CarPlaceholder = "car-placeholder"
}

struct ServerConstants {
    static var serverPath: String {
        let path = Bundle.main.infoDictionary?["ServerURL"] as! String

        return path.replacingOccurrences(of: "\\", with: "")
    }
}

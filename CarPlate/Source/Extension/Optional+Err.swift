//
//  Optional+Err.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 10.04.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation

extension Optional {
    var isNotNil: Bool {
        switch self {
        case .some:
            return true
        case .none:
            return false
        }
    }

    var isNil: Bool {
        switch self {
        case .some:
            return false
        case .none:
            return true
        }
    }
}

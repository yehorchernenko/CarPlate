//
//  String+Ext.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 15.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var valueOrEmpty: String {
        switch self {
        case .some(let value):
            return value
        case .none:
            return ""
        }
    }
}

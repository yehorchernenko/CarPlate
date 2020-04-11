//
//  ServiceError.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 10.04.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation

struct ServiceError: Error, Codable {
    let code: Int?
    let message: String?

    static let unknown = ServiceError(code: -1, message: "Unknown error")
    static let duplicate = ServiceError(code: -2, message: "Duplicate")
}

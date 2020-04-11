//
//  PresentableError.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 10.04.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation

struct PresentableError: Identifiable {
    let id: Int
    let title: String
    let message: String

    static let empty: PresentableError = .init(id: 0, title: "", message: "")
}

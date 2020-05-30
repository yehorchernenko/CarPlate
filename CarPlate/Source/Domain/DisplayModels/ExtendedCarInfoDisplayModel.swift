//
//  ExtendedCarInfoDisplayModel.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 28.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation

struct ExtendedCarInfoDisplayModel: Identifiable {
    let item: ExtendedCarInfo

    var id: String {
        return vin
    }

    var vin: String {
        return item.carInfo.vin.valueOrEmpty
    }

    var estimatedPrice: String? {
        guard let estimatedPrice = item.estimatedPrice else { return nil }
        let formatter = NumberFormatter()
        formatter.currencyCode = "usd"

        return formatter.string(from: NSNumber(value: estimatedPrice))
    }

    static let empty: ExtendedCarInfoDisplayModel = .init(item: .empty)
    static let fake: ExtendedCarInfoDisplayModel = .init(item: .fake)
}

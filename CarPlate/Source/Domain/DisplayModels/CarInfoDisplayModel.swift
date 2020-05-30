//
//  CarInfoDisplayModel.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 27.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation

struct CarInfoDisplayModel: Identifiable {
    private let item: CarInfo
    
    init(item: CarInfo) {
        self.item = item
    }

    var dbId: Int {
        return item.id
    }
    
    var id: String {
        return "\(item.nRegNew)\(item.dReg.valueOrEmpty)"
    }
    
    var name: String {
        if item.brand.valueOrEmpty.contains(item.model.valueOrEmpty) {
            return item.brand.valueOrEmpty
        } else {
            return "\(item.brand.valueOrEmpty) \(item.model.valueOrEmpty)"
        }
    }
    
    var carPlateNumber: String {
        return item.nRegNew
    }
    
    var brand: String {
        if item.brand.valueOrEmpty.contains(item.model.valueOrEmpty) {
            return item.brand.valueOrEmpty.replacingOccurrences(of: item.model.valueOrEmpty, with: "").trimmingCharacters(in: .whitespaces)
        } else {
            return item.brand.valueOrEmpty
        }
    }

    var model: String {
        if item.brand.valueOrEmpty.contains(item.model.valueOrEmpty) {
            return item.model.valueOrEmpty.replacingOccurrences(of: item.brand.valueOrEmpty, with: "")
        } else {
            return item.model.valueOrEmpty
        }
    }

    var year: String {
        guard let year = item.makeYear else { return "" }
        return "\(year)"
    }

    var color: String {
        return item.color.valueOrEmpty
    }

    var capacity: String {
        return item.capacity.valueOrEmpty
    }

    var kind: String {
        return item.kind.valueOrEmpty
    }

    var ownAndTotalWeight: String {
        return "\(item.ownWeight.valueOrEmpty)/\(item.totalWeight.valueOrEmpty)"
    }

    var fuel: String {
        return "\(item.fuel.valueOrEmpty)"
    }

    var formattedColor: String {
        return "Colour: \(color)"
    }
    
    var formattedYear: String {
        return "Year: \(year)"
    }
    
    var formattedCapacity: String {
        return "Capacity: \(item.capacity.valueOrEmpty)"
    }

    var characteristics: [Characteristic] {
        return [
            Characteristic(imageName: "color-circle", type: "Color", value: color),
            Characteristic(imageName: "engine", type: "Capacity", value: capacity),
            Characteristic(imageName: "fuel", type: "Fuel", value: fuel),
            Characteristic(imageName: "car-type", type: "Type", value: kind),
            Characteristic(imageName: "weight", type: "Own / Total weight", value: ownAndTotalWeight),

        ]
    }

    var lastRecord: String {
        return item.operName.valueOrEmpty
    }

    var lastRecordDate: String {
        return item.dReg.valueOrEmpty
    }

    var region: String {
        guard item.nRegNew.count >= 8 else { return "" }
        
        let secondCharIndex = item.nRegNew.index(after: item.nRegNew.startIndex)
        return String(item.nRegNew[item.nRegNew.startIndex...secondCharIndex])
    }

    var regionName: String {
        return regionsNames[region].valueOrEmpty
    }

    var formattedLicensePlate: String {
        guard item.nRegNew.count >= 8 else { return "" }

        let secondCharIndex = item.nRegNew.index(after: item.nRegNew.index(after: item.nRegNew.startIndex))
        var formattedLicensePlate = item.nRegNew
        formattedLicensePlate.insert(" ", at: secondCharIndex)

        let beforeLastCharIndex = formattedLicensePlate.index(before: formattedLicensePlate.index(before: formattedLicensePlate.endIndex))
        formattedLicensePlate.insert(" ", at: beforeLastCharIndex)

        return formattedLicensePlate
    }

    var brandImageUrl: URL? {
        guard let imagePath = item.brandImageURL else { return nil }
        return URL(string: imagePath)
    }
    
    struct Characteristic: Hashable {
        let imageName: String
        let type: String
        let value: String
    }

    static var empty: Self = .init(item: .empty)

    static var fake: Self {
        return .init(item: .fake)
    }
}

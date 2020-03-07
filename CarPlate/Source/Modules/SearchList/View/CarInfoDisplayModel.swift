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
        return item.brand.valueOrEmpty
    }
    
    var color: String {
        return "Colour: \(item.color.valueOrEmpty)"
    }
    
    var year: String {
        guard let year = item.makeYear else { return "" }
        return "Year: \(year)"
    }
    
    var capacity: String {
        return "Capacity: \(item.capacity.valueOrEmpty)"
    }
}

//
//  ExtendedCarInfo.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 28.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation

struct ExtendedCarInfo: Codable {
    var carInfo: OpenDataCarInfo
    var estimatedPrice: Double?

    struct OpenDataCarInfo: Codable {
        var sDoc: String?
        var nDoc: String?
        var number: String?
        var nRegNew: String?
        var brand: String?
        var capacity: String?
        var color: String?
        var fuel: String?
        var kind: String?
        var model: String?
        var nSeating: String?
        var rankCategory: String?
        var ownWeight: String?
        var makeYear: String?
        var totalWeight: String?
        var dFirstReg: String?
        var dReg: String?
        var vin: String?

        // MARK: - For debug reason

        static func fixture(
            sDoc: String? = nil,
            nDoc: String? = nil,
            number: String? = nil,
            nRegNew: String? = nil,
            brand: String? = nil,
            capacity: String? = nil,
            color: String? = nil,
            fuel: String? = nil,
            kind: String? = nil,
            model: String? = nil,
            nSeating: String? = nil,
            rankCategory: String? = nil,
            ownWeight: String? = nil,
            makeYear: String? = nil,
            totalWeight: String? = nil,
            dFirstReg: String? = nil,
            dReg: String? = nil,
            vin: String? = nil) -> OpenDataCarInfo {
            return OpenDataCarInfo(
                sDoc: sDoc,
                nDoc: nDoc,
                number: number,
                nRegNew: nRegNew,
                brand: brand,
                capacity: capacity,
                color: color,
                fuel: fuel,
                kind: kind,
                model: model,
                nSeating: nSeating,
                rankCategory: rankCategory,
                ownWeight: ownWeight,
                makeYear: makeYear,
                totalWeight: totalWeight,
                dFirstReg: dFirstReg,
                dReg: dReg,
                vin: vin)
        }
    }

    static func fixture(carInfo: OpenDataCarInfo = .fixture(),
                        estimatedPrice: Double? = nil) -> ExtendedCarInfo {
        return ExtendedCarInfo(carInfo: carInfo,
                               estimatedPrice: estimatedPrice)
    }

    static let empty: ExtendedCarInfo = .fixture()

    static var fake: ExtendedCarInfo {
        guard let data = """
        {
          "carInfo": {
            "sDoc": "СХІ",
            "nDoc": "366003",
            "number": "СХІ366003",
            "nRegNew": "АХ0069КХ",
            "brand": "NISSAN",
            "capacity": "1598",
            "color": "БІЛИЙ",
            "fuel": "БЕНЗИН АБО ГАЗ",
            "kind": "ЛЕГКОВИЙ ХЕТЧБЕК-В",
            "model": "JUKE",
            "nSeating": "5",
            "rankCategory": "АВТОМОБ",
            "ownWeight": "1295",
            "makeYear": "2017",
            "totalWeight": "1870",
            "dFirstReg": "2017-10-07",
            "dReg": "2018-11-16",
            "vin": "SJNFBAF15U7383292"
          },
          "estimatedPrice": 15283.266666666666
        }
        """.data(using: .utf8) else { return .empty }

        return try! JSONDecoder().decode(ExtendedCarInfo.self, from: data)

    }
}

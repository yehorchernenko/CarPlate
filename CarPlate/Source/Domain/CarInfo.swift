//
//  CarInfo.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 16.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation

struct CarInfo: Codable, Identifiable {
    let person: String?
    let regAddrKoatuu: String?
    let operCode: String?
    let operName: String?
    let dReg: String?
    let depCode: Int?
    let dep: String?
    let brand: String?
    let model: String?
    let makeYear: Int?
    let color: String?
    let kind: String?
    let body: String?
    let purpose: String?
    let fuel: String?
    let capacity: String?
    let ownWeight: String?
    let totalWeight: String?
    let nRegNew: String
    
    var id: String {
        return nRegNew
    }
    
    static func fixture(
        person: String? = nil,
        regAddrKoatuu: String? = nil,
        operCode: String? = nil,
        operName: String? = nil,
        dReg: String? = nil,
        depCode: Int? = nil,
        dep: String? = nil,
        brand: String? = nil,
        model: String? = nil,
        makeYear: Int? = nil,
        color: String? = nil,
        kind: String? = nil,
        body: String? = nil,
        purpose: String? = nil,
        fuel: String? = nil,
        capacity: String? = nil,
        ownWeight: String? = nil,
        totalWeight: String? = nil,
        nRegNew: String = "") -> CarInfo {
        return .init(
            person: person,
            regAddrKoatuu: regAddrKoatuu,
            operCode: operCode,
            operName: operName,
            dReg: dReg,
            depCode: depCode,
            dep: dep,
            brand: brand,
            model: model,
            makeYear: makeYear,
            color: color,
            kind: kind,
            body: body,
            purpose: purpose,
            fuel: fuel,
            capacity: capacity,
            ownWeight: ownWeight,
            totalWeight: totalWeight,
            nRegNew: nRegNew)
    }
    
    static var fakeList: [Self] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try! decoder.decode([CarInfo].self, from: data)
    }

    static var fake: Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try! decoder.decode([CarInfo].self, from: data).first!
    }
    
    static let data: Data = """
[
{
  "person": "P",
  "reg_addr_koatuu": "6311200000",
  "oper_code": "308",
  "oper_name": "ПЕРЕРЕЄСТРАЦІЯ НА НОВОГО ВЛАСНИКА ЗА ДОГ. КУПIВЛI-ПРОДАЖУ (СГ)",
  "d_reg": "30.11.2019",
  "dep_code": 13653,
  "dep": "ТСЦ 6350",
  "brand": "KIA",
  "model": "RIO",
  "make_year": 2013,
  "color": "БІЛИЙ",
  "kind": "ЛЕГКОВИЙ",
  "body": "СЕДАН-B",
  "purpose": "ЗАГАЛЬНИЙ",
  "fuel": "БЕНЗИН АБО ГАЗ",
  "capacity": "1396",
  "own_weight": "1160",
  "total_weight": "1565",
  "n_reg_new": "АХ5141НТ"
},
{
  "person": "P",
  "reg_addr_koatuu": "6310136600",
  "oper_code": "71",
  "oper_name": "РЕЄСТРАЦІЯ ТЗ ПРИВЕЗЕНОГО З-ЗА КОРДОНУ ПО ПОСВІДЧЕННЮ МИТНИЦІ",
  "d_reg": "21.11.2019",
  "dep_code": 13653,
  "dep": "ТСЦ 6350",
  "brand": "VOLKSWAGEN",
  "model": "JETTA",
  "make_year": 2015,
  "color": "СІРИЙ",
  "kind": "ЛЕГКОВИЙ",
  "body": "СЕДАН-B",
  "purpose": "ЗАГАЛЬНИЙ",
  "fuel": "БЕНЗИН",
  "capacity": "1984",
  "own_weight": "1272",
  "total_weight": "1960",
  "n_reg_new": "АХ5140НТ"
}
]
""".data(using: .utf8)!
}

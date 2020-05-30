//
//  Policy.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 30.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation

struct Policy: Codable {
    let webSiteURL: String
    let endScripts: [String]
    let endScriptsWithParams: [String]
}

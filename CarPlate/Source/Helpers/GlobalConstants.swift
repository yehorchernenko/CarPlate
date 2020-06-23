//
//  GlobalConstants.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 28.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import UIKit
import SwiftUI

enum Assets {
    static let CarPlaceholder = "car-placeholder"
}

struct ServerConstants {
    static var serverPath: String {
        let path = Bundle.main.infoDictionary?["ServerURL"] as! String

        return path.replacingOccurrences(of: "\\", with: "")
    }
}

enum Translation {

    static var searchNavTitle: LocalizedStringKey {
        return "search.nav.title"
    }

    static var searchCellColor: LocalizedStringKey {
        return "search.cell.color"
    }
    static var searchCellYear: LocalizedStringKey {
        return "search.cell.year"
    }
    static var searchCellCapacity: LocalizedStringKey {
        return "search.cell.capacity"
    }

    static var detailsTitle: LocalizedStringKey {
        return "details.title"
    }
}

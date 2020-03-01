//
//  CarDetails.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 29.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI

struct CarDetailsView: View {
    var details: CarInfoDisplayModel
    var body: some View {
        Text(details.brand)
    }
}

//struct CarDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        CarDetailsView(details: "String")
//    }
//}

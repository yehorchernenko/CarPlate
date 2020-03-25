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
        VStack {
            VStack {
                Text(details.brand)
                Text(details.brand)
                Text(details.brand)
                Text(details.brand)
            }.padding()

            VStack {
                Text(details.brand)
                Text(details.brand)
                Text(details.brand)
                Text(details.brand)
            }.padding()

            VStack {
                Text(details.brand)
                Text(details.brand)
                Text(details.brand)
                Text(details.brand)
            }.padding()

            VStack {
                Text("Check")
                Text(details.brand)
                Text(details.brand)
                Text(details.brand)
            }.padding()

            VStack {
                Text(details.brand)
                Text(details.brand)
                Text(details.brand)
                Text(details.brand)
            }.padding()

        }
    }
}

struct CarDetails_Previews: PreviewProvider {
    static var previews: some View {
        CarDetailsView(details: CarInfoDisplayModel(item: .fake))
    }
}

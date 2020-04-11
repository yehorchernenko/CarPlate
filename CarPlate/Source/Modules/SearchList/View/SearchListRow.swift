//
//  SearchListRow.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 15.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI

struct SearchListRow: View {
    let item: CarInfoDisplayModel
    
    var carInfo: some View {
        HStack {
            Text("\(item.name)")
            Spacer()
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image("KIA")
                        .resizable().scaledToFit()
                        .frame(width: 30, height: 30)
                    carInfo
                }
                CarPlateView(number: item.carPlateNumber)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(item.formattedColor)
                Text(item.formattedYear)
                Text(item.formattedCapacity)
            }.font(.caption)
        }
        .padding()
        .background(Color.primary.colorInvert())
        .cornerRadius(12)
        .shadow(color: Color.searchListRowShadow, radius: 10, x: 0, y: 0)
    }
}

struct SearchListRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchListRow(item: CarInfoDisplayModel(item: .fixture())).colorScheme(.light)
                .padding()
            SearchListRow(item: CarInfoDisplayModel(item: .fixture())).colorScheme(.dark)
            .padding()
        }
        .previewLayout(.fixed(width: 350, height: 100))
    }
}

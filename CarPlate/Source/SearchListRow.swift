//
//  SearchListRow.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 15.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI

struct SearchListRow: View {
    let item: CarInfo
    
    var carInfo: some View {
        HStack {
            Text("\(item.brand.valueOrEmpty) \(item.model.valueOrEmpty)")
//            Text("\(NumberFormatter().string(from: NSNumber(value: item.makeYear ?? 0)) ?? "")")
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
                CarPlateView(number: item.nRegNew)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Color: Red")
                Text("Year: 2013")
                Text("Capacity: 1984")
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
            SearchListRow(item: CarInfo.list.first!).colorScheme(.light)
                .padding()
            SearchListRow(item: CarInfo.list.last!).colorScheme(.dark).background(Color.black).padding()
        }
        .previewLayout(.fixed(width: 350, height: 100))
    }
}


extension View {
    func troto() {
        
    }
}

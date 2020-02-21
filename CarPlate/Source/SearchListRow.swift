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
            Image(item.brand.valueOrEmpty)
                .resizable().scaledToFit()
                .frame(width: 30, height: 30)
            
            Text("\(item.brand.valueOrEmpty) \(item.model.valueOrEmpty)")
            Spacer()
            Text("\(NumberFormatter().string(from: NSNumber(value: item.makeYear ?? 0)) ?? "")")
        }
    }
    
    var body: some View {
        VStack {
            carInfo
            HStack {
                CarPlateView(number: item.nRegNew)
                Spacer()
                Text("Color: \(item.color.valueOrEmpty)")
            }
        }
        .padding()
        .background(Color.primary.colorInvert())
        .cornerRadius(12)
        .shadow(color: Color(.systemGray3), radius: 5, x: 0, y: 0)
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


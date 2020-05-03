//
//  CarPlateView.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 20.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI

struct CarPlateView: View {
    let number: String
    
    var flag: some View {
        VStack(spacing: 0) {
            Color(.systemTeal)
            Color(.yellow)
        }
        .frame(height: 4)
        .padding([.leading, .trailing], 2)
    }
    
    var countryText: some View {
        Text("UA")
            .font(.system(size: 5))
            .fontWeight(.medium)
            .foregroundColor(.white)
    }
    
    var country: some View {
        VStack(alignment: .center, spacing: 2) {
            flag
            countryText
        }.padding(.leading, 1)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            country
                .frame(maxWidth: 10, maxHeight: .infinity)
                .background(Color.carPlateCountry)
            
            Text(number.uppercased())
                .font(.headline).padding([.leading, .trailing], 4)
        }
        .frame(height: 20)
        .clipShape(RoundedRectangle(cornerRadius: 3))
        .border(Color.primary, width: 1)
        .cornerRadius(3)
    }
}

struct CarPlateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CarPlateView(number: "АА 0000 АА")
                .previewLayout(.fixed(width: 200, height: 60))
                .colorScheme(.light)
            CarPlateView(number: "АА 0000 АА")
                .colorScheme(.dark)
                .background(Color.black)
                .previewLayout(.fixed(width: 200, height: 60))
        }
    }
}

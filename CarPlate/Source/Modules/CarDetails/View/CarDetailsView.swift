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

    var topView: some View {
        VStack {
            Text("Goverment register")
            Divider()
            HStack {
                Image("KIA")
                    .resizable().scaledToFit()
                    .frame(width: 80, height: 80)
                VStack {
                    Divider()
                }.padding()
                VStack(alignment: .trailing) {
                    Text(details.brand)
                    Text(details.model)
                    Text(details.year)
                }.padding(.trailing)
            }
            Divider()
        }
    }

    var characteristicCarousel: some View {
        VStack(alignment: .leading) {
            Text("Properties")
                .fontWeight(.ultraLight)
                .font(.system(size: 15))
            HStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(details.characteristics, id: \.self) { item in
                            CarDetailsCarouselCell(item: item)
                        }
                    }
                }
            }
            Divider()
        }
    }

    var body: some View {
        VStack {
            topView
            characteristicCarousel
            Spacer()
        }
        .padding()
        .background(Color.primary.colorInvert())
    }
}

struct CarDetails_Previews: PreviewProvider {
    static var previews: some View {
        CarDetailsView(details: CarInfoDisplayModel(item: .fake))
    }
}

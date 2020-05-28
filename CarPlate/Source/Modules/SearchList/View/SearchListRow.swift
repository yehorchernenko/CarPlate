//
//  SearchListRow.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 15.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI

struct SearchListRow: View {
    @Environment(\.imageCache) var cache: ImageCache
    let item: CarInfoDisplayModel

    var brandImage: some View {
        AsyncImage(url: item.brandImageUrl,
                   placeholder: Image(Assets.CarPlaceholder)
                    .resizable()
                    .frame(width: 30, height: 30),
                   cache: cache,
                   configuration: { image in
                    AnyView(image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(2))

        })
            .frame(width: 30, height: 30)
    }
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
                    brandImage
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

//
//  CarDetailsCarouselCell.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 09.04.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI

struct CarDetailsCarouselCell: View {
    var item: CarInfoDisplayModel.Characteristic

    var body: some View {
        VStack {
            Image(item.imageName)
                .resizable().scaledToFit()
                .frame(width: 40, height: 40)
            VStack {
                Text(item.type)
                    .fontWeight(.ultraLight)
                    .font(.system(size: 15))
                Text(item.value)
                    .font(.system(size: 15))
            }
        }
    }
}

struct CarDetailsCarouselCell_Previews: PreviewProvider {
    static var previews: some View {
        CarDetailsCarouselCell(item: CarInfoDisplayModel.fake.characteristics.first!)
    }
}

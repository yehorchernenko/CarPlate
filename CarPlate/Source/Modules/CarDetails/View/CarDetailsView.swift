//
//  CarDetails.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 29.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI

struct CarDetailsView: View {

    @ObservedObject var viewModel: CarDetailsViewModel

    var topView: some View {
        VStack {
            Text("Goverment register")
                .fontWeight(.semibold)
            Divider()
            HStack {
                Image("KIA")
                    .resizable().scaledToFit()
                    .frame(width: 80, height: 80)
                VStack {
                    Divider()
                }.padding()
                VStack(alignment: .trailing) {
                    Text(viewModel.details.brand)
                    Text(viewModel.details.model)
                    Text(viewModel.details.year)
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
                        ForEach(viewModel.details.characteristics, id: \.self) { item in
                            CarDetailsCarouselCell(item: item)
                        }
                    }
                }
            }
            Divider()
        }
    }

    var region: some View {
        VStack {
            HStack {
                Text(viewModel.details.region)
                    .fontWeight(.heavy)
                    .font(.system(size: 32))
                VStack(alignment: .leading) {
                    Text("Region name:")
                        .fontWeight(.ultraLight)
                    Text(viewModel.details.regionName)
                }
                .font(.system(size: 15))
                Spacer()
            }
            Divider()
        }
    }

    var lastRecord: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Last record by this license plate:")
                        .fontWeight(.semibold)

                    VStack(alignment: .leading) {
                        Text(viewModel.details.lastRecord)
                        HStack {
                            Text("Recording date:")
                                .fontWeight(.ultraLight)
                            Text(viewModel.details.lastRecordDate)
                        }
                    }.padding(.leading, 4)
                        .font(.system(size: 15))
                }
                Spacer()
            }
            Divider()
        }
    }

    var body: some View {
        VStack {
            topView
            characteristicCarousel
            region
            lastRecord
            Spacer()
        }.onAppear(perform: {
            self.viewModel.onViewAppear()
        })
            .padding()
            .background(Color.primary.colorInvert())
    }
}

struct CarDetails_Previews: PreviewProvider {
    static var previews: some View {
        CarDetailsView(viewModel: CarDetailsViewModel(recognizedText: .constant("")))
    }
}

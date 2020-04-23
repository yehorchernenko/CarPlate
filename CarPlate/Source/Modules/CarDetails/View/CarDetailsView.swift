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

    var body: some View {
        VStack {
            topView
            characteristicCarousel
            Text(viewModel.searchText)
            Spacer()
        }.onAppear(perform: {
            self.viewModel.load()
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

class CarDetailsViewModel: ObservableObject {
    @Environment(\.searchService) var searchService: SearchServiceType
    @Environment(\.storageService) var storageService: StorageServiceType

    @Published var details: CarInfoDisplayModel = .empty
    @Binding var searchText: String {
        didSet {

        }
    }

    init(recognizedText: Binding<String>) {
        _searchText = recognizedText
    }

    func load() {
        guard let carInfo = storageService.single(byNumber: searchText) else {
            return
        }

        details = .init(item: carInfo)
    }
}

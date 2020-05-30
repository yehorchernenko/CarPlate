//
//  CarDetails.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 29.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI

struct CarDetailsView: View {
    @Environment(\.imageCache) var cache: ImageCache
    @ObservedObject var viewModel: CarDetailsViewModel

    var image: some View {
        AsyncImage(url: viewModel.details.brandImageUrl,
                   placeholder: Image(Assets.CarPlaceholder)
                    .resizable()
                    .frame(width: 80, height: 80),
                   cache: cache,
                   configuration: { image in
                    AnyView(image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(2))
                    
        })
            .frame(width: 80, height: 80)
    }

    var topView: some View {
        VStack {
            Text("Goverment register")
                .fontWeight(.semibold)
            CarPlateView(number: viewModel.details.formattedLicensePlate)
            Divider()
            HStack {
                image
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

            if viewModel.isShowAllRecordsVisible {
                Button(action: {
                    self.viewModel.onAllRecordsTouched()
                }) {
                    HStack {
                        Text("All records")
                        Image(systemName: "chevron.right")
                    }
                }
            }

            Divider()
        }
    }

    var policyButton: some View {
        VStack {
            Button(action: {
                self.viewModel.onPolicyButtonTouched()
            }) {
                HStack {
                    Text("Check policy")
                    Image(systemName: "chevron.right")
                }
            }
            Divider()
        }
    }

    var moreInfoButton: some View {
        Button(action: {
            self.viewModel.onMoreInfoTouched()
        }) {
            HStack {

                Text("More info")
                Image(systemName: "chevron.down")
            }
        }
    }

    var moreInfoView: some View {
        VStack {
            HStack {
                Image("vin")
                    .resizable().scaledToFit()
                    .frame(width: 40, height: 40)
                Text(viewModel.extendedDetails.vin)
                    .font(.system(size: 15))
                Spacer()
            }
            if viewModel.extendedDetails.estimatedPrice.isNotNil {
                HStack {
                    Image("price")
                        .resizable().scaledToFit()
                        .frame(width: 40, height: 40)
                    Text(viewModel.extendedDetails.estimatedPrice.valueOrEmpty)
                        .font(.system(size: 15))
                    Spacer()
                }
            }
        }
    }

    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    topView
                    characteristicCarousel
                    region
                    lastRecord
                    policyButton
                    if viewModel.shouldShowMoreDetails {
                        moreInfoView
                    } else {
                        moreInfoButton
                    }
                    Spacer()
                }.onAppear(perform: {
                    self.viewModel.onViewAppear()
                })
                    .padding()
                ActivityIndicator(isAnimating: $viewModel.isLoading)
            }
            navigationLinks
        }
        .background(Color.primary.colorInvert())
    }

    var navigationLinks: some View {
        Group {
            NavigationLink(destination:
                HistoryList(records: viewModel.allRecords)
                , isActive: $viewModel.isAllRecordsLinkActive, label: { EmptyView() })

            NavigationLink(destination:
                PolicyView(viewModel: PolicyViewModel(carPlateNumber: viewModel.details.carPlateNumber))
                , isActive: $viewModel.isPolicyLinkActive, label: { EmptyView() })
        }
    }
}

struct CarDetails_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CarDetailsView(viewModel: CarDetailsViewModel_Previews(carPlateNumber: .constant("")))
            CarDetailsView(viewModel: CarDetailsViewModel_Previews(carPlateNumber: .constant(""))).colorScheme(.dark)
        }
    }
}

private class CarDetailsViewModel_Previews: CarDetailsViewModel {

    override func onViewAppear() {
        details = .fake
        shouldShowMoreDetails = true
    }

    override func didUpdateSearchText(_ searchText: String) {
        details = .fake
    }

    override func onMoreInfoTouched() {
        extendedDetails = .fake
        shouldShowMoreDetails = true
    }

    override func onAllRecordsTouched() {

    }

    override func loadFromStorage() {
        details = .fake
    }
}

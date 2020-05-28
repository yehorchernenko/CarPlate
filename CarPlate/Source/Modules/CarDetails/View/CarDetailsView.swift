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
            CarPlateView(number: viewModel.details.carPlateNumber)
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

            Button(action: {
                self.viewModel.onAllRecordsTouched()
            }) {
                HStack {
                    Text("All records")
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
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
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
                //extract to new file
                ScrollView {
                    ForEach(viewModel.allRecords) { item in
                        NavigationLink(destination: CarDetailsView(viewModel: CarDetailsViewModel(carPlateNumber: .constant(item.carPlateNumber)))) {
                            SearchListRow(item: item)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    .background(Color.searchListViewBg)
                    .padding([.leading, .trailing])
                }
                , isActive: $viewModel.shouldShowAllRecords, label: { EmptyView() })
        }
    }
}

struct CarDetails_Previews: PreviewProvider {
    static var previews: some View {
        CarDetailsView(viewModel: CarDetailsViewModel(carPlateNumber: .constant("")))
    }
}

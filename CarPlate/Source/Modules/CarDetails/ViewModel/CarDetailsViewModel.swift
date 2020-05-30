//
//  CarDetailsViewModel.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 23.04.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI
import Combine

class CarDetailsViewModel: ObservableObject {
    // MARK: - Environment
    @Environment(\.searchService) var searchService: SearchServiceType
    @Environment(\.storageService) var storageService: StorageServiceType

    @Binding var searchText: String
    @Published var details: CarInfoDisplayModel = .empty
    @Published var allRecords: [CarInfoDisplayModel] = []
    @Published var extendedDetails: ExtendedCarInfoDisplayModel = .fake

    // MARK: - Enablers
    @Published var isLoading: Bool = false
    @Published var isShowAllRecordsVisible: Bool = true

    @Published var shouldShowMoreDetails: Bool = false
    @Published var isAllRecordsLinkActive: Bool = false
    @Published var isPolicyLinkActive: Bool = false

    private var searchToken: Cancellable?
    private var searchManyToken: Cancellable?
    private var moreToken: Cancellable?
    
    init(carPlateNumber: Binding<String>) {
        _searchText = carPlateNumber
    }

    func didUpdateSearchText(_ searchText: String) {
        isLoading.toggle()
        searchToken?.cancel()
        searchToken = searchService
            .search(byCarPlate: searchText.uppercased())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    //self.toggleError(error)
                    break

                case .finished:
                    break
                }
                self.isLoading.toggle()
            }) { [weak self] carInfo in
                self?.details = CarInfoDisplayModel(item: carInfo)
                self?.storageService.saveIfUnique(carInfo: carInfo)
        }
    }

    func onViewAppear() {
        guard !searchText.isEmpty else { return }
        loadFromStorage()
    }

    func onAllRecordsTouched() {
        isLoading.toggle()
        searchManyToken = searchService
            .searchMany(byCarPlate: searchText.uppercased())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    //self.toggleError(error)
                    break

                case .finished:
                    break
                }
                self.isLoading.toggle()
            }) { [weak self] allRecords in
                self?.allRecords = allRecords.compactMap { CarInfoDisplayModel(item: $0)}
                self?.isAllRecordsLinkActive.toggle()
        }
    }

    func onPolicyButtonTouched() {
        isPolicyLinkActive.toggle()
    }

    func onMoreInfoTouched() {
        isLoading.toggle()
        moreToken = searchService
            .more(byCarPlate: searchText.uppercased())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    //self.toggleError(error)
                    break

                case .finished:
                    break
                }

                self.isLoading.toggle()
            }, receiveValue: { [weak self] fullCarInfo in
                self?.extendedDetails = .init(item: fullCarInfo)
                self?.shouldShowMoreDetails.toggle()
            })
    }

    func loadFromStorage() {
        guard let carInfo = storageService.single(byNumber: searchText) else {
            return
        }

        details = .init(item: carInfo)
    }
}

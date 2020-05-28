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
    @Environment(\.searchService) var searchService: SearchServiceType
    @Environment(\.storageService) var storageService: StorageServiceType
    private var searchToken: Cancellable?
    private var searchManyToken: Cancellable?
    @Published var details: CarInfoDisplayModel = .fake
    @Published var allRecords: [CarInfoDisplayModel] = []
    @Binding var searchText: String
    @Published var isLoading: Bool = false
    @Published var isShowAllRecordsVisible: Bool = true
    @Published var shouldShowMoreDetails: Bool = false
    @Published var shouldShowAllRecords: Bool = false
    
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
                self?.isLoading.toggle()
        }
    }

    func onViewAppear() {
        guard !searchText.isEmpty else { return }
        loadFromStorage()
    }

    func onMoreInfoTouched() {
        shouldShowMoreDetails.toggle()
        isLoading.toggle()
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
                self?.isLoading.toggle()
                self?.shouldShowAllRecords.toggle()
        }
    }

    func loadFromStorage() {
        guard let carInfo = storageService.single(byNumber: searchText) else {
            return
        }

        details = .init(item: carInfo)
    }
}

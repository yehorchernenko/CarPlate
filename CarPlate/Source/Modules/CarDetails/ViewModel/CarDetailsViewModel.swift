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
    private var token: Cancellable?
    @Published var details: CarInfoDisplayModel = .fake
    @Binding var searchText: String
    @Published var isLoading: Bool = false
    @Published var shouldShowMoreDetails: Bool = false

    
    init(recognizedText: Binding<String>) {
        _searchText = recognizedText
    }

    func didUpdateSearchText(_ searchText: String) {
        isLoading.toggle()
        token?.cancel()
        token = searchService.search(byCarPlate: searchText.uppercased()).sink(receiveCompletion: { completion in
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
}

private extension CarDetailsViewModel {
    func loadFromStorage() {
        guard let carInfo = storageService.single(byNumber: searchText) else {
            return
        }

        details = .init(item: carInfo)
    }
}

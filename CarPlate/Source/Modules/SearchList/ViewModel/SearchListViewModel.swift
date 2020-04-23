//
//  SearchListViewModel.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 22.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class SearchListViewModel: ObservableObject {
    @Environment(\.searchService) var searchService: SearchServiceType
    @Environment(\.storageService) var storageService: StorageServiceType
    private var token: Cancellable?
    @Published var list = [CarInfoDisplayModel]()
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var error: PresentableError?
    
    func onSearchTouched() {
        isLoading.toggle()
        token?.cancel()
        token = searchService.search(byCarPlate: searchText.uppercased())
            .sink(receiveCompletion: { completion in

                switch completion {
                case .failure(let error):
                    self.toggleError(error)
                    
                case .finished:
                    break
                }
                self.isLoading.toggle()
            }) { [weak self] carInfo in
                self?.list.append(CarInfoDisplayModel(item: carInfo))
                self?.storageService.saveIfUnique(carInfo: carInfo)
        }
    }
    
    func load() {
        list = storageService.retrieve().map { CarInfoDisplayModel(item: $0)}.reversed()
    }

    func toggleError(_ error: ServiceError) {
        self.error = PresentableError(id: error.code ?? 0, title: "Error", message: error.message.valueOrEmpty)
    }

}

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
    private var timer: Cancellable?
    @Published var list = [CarInfoDisplayModel]()
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var error: PresentableError?
    
    func onSearchTouched() {
        isLoading.toggle()
        token?.cancel()
        token = searchService.search(byCarPlate: searchText.uppercased())
            .map {
                self.storageService.save(carInfo: $0)
                return CarInfoDisplayModel(item: $0) }
            .sink(receiveCompletion: { completion in

                switch completion {
                case .failure(let error):
                    self.toggleError(error)
                    
                case .finished:
                    break
                }
                self.isLoading.toggle()
            }) { [weak self] info in
                self?.list.append(info)
        }
    }
    
    func load() {
        list = storageService.retrieve().map { CarInfoDisplayModel(item: $0)}
    }

    func toggleError(_ error: ServiceError) {
        self.error = PresentableError(id: error.code ?? 0, title: "Error", message: error.message.valueOrEmpty)
    }
}

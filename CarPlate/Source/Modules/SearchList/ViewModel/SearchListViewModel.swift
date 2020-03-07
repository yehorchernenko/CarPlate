//
//  SearchListViewModel.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 22.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Combine
import Foundation

class SearchListViewModel: ObservableObject {
    private let searchService: SearchServiceType
    private let storageService: StorageServiceType
    private var token: Cancellable?
    @Published var list = [CarInfoDisplayModel]()
    @Published var searchText = ""
    @Published var isLoading = false
    
    init(searchService: SearchService, storageService: StorageServiceType) {
        self.searchService = searchService
        self.storageService = storageService
    }
    
    func onSearchTouched() {
        isLoading.toggle()
        token?.cancel()
        token = searchService.search(byCarPlate: searchText.uppercased())
            .map {
                self.storageService.save(carInfo: $0)
                return CarInfoDisplayModel(item: $0) }
            .sink(receiveCompletion: { _ in
                self.isLoading.toggle()
            }) { [weak self] info in
                self?.list.append(info)
        }
    }
    
    func load() {
        list = storageService.retrieve().map { CarInfoDisplayModel(item: $0)}
    }
}

class SearchListViewModelMock: SearchListViewModel {
    init() {
        super.init(searchService: SearchService(agent: NetworkAgent()), storageService: StorageService())
    }
}

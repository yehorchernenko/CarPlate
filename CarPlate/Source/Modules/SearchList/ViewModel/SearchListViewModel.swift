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
    private var token: Cancellable?
    @Published var list = [CarInfoDisplayModel]()
    @Published var searchText = ""
    @Published var isLoading = false
    
    init(searchService: SearchService) {
        self.searchService = searchService
    }
    
    func onSearchTouched() {
        isLoading.toggle()
        token?.cancel()
        token = searchService.search(byCarPlate: searchText.uppercased())
            .map { list in
                list.map { CarInfoDisplayModel(item: $0) }}
            .sink(receiveCompletion: { _ in
                self.isLoading.toggle()
            }) { [weak self] list in
                guard let first = list.first else { return }
                self?.list.append(first)
        }
    }
    
    func load() {
        
    }
}

class SearchListViewModelMock: SearchListViewModel {
    init() {
        super.init(searchService: SearchService(agent: NetworkAgent()))
    }
}

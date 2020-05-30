//
//  SearchService.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 27.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

protocol SearchServiceType {
    func search(byCarPlate carPlate: String) -> AnyPublisher<CarInfo, ServiceError>
    func searchMany(byCarPlate carPlate: String) -> AnyPublisher<[CarInfo], ServiceError>
    func search(byId id: Int) -> AnyPublisher<CarInfo, ServiceError>
    func more(byCarPlate carPlate: String) -> AnyPublisher<ExtendedCarInfo, ServiceError>
}

class SearchService: SearchServiceType {
    private let agent: NetworkAgent
    
    init(agent: NetworkAgent) {
        self.agent = agent
    }
    
    func search(byCarPlate carPlate: String) -> AnyPublisher<CarInfo, ServiceError> {
        let request = SearchEndpoint.searchByCarPlate(carPlate: carPlate).request
        return agent.run(request: request).map(\.value).eraseToAnyPublisher()
    }

    func searchMany(byCarPlate carPlate: String) -> AnyPublisher<[CarInfo], ServiceError> {
        let request = SearchEndpoint.searchMany(byCarPlate: carPlate).request
        return agent.run(request: request).map(\.value).eraseToAnyPublisher()
    }

    func search(byId id: Int) -> AnyPublisher<CarInfo, ServiceError> {
        let request = SearchEndpoint.searchById(id: id).request
        return agent.run(request: request).map(\.value).eraseToAnyPublisher()
    }

    func more(byCarPlate carPlate: String) -> AnyPublisher<ExtendedCarInfo, ServiceError> {
        let request = SearchEndpoint.more(byCarPlate: carPlate).request
        return agent.run(request: request).map(\.value).eraseToAnyPublisher()
    }
}

struct SearchServiceKey: EnvironmentKey {
    static var defaultValue: SearchServiceType = SearchService(agent: NetworkAgent())
}

extension EnvironmentValues {
    var searchService: SearchServiceType {
        get { self[SearchServiceKey.self] }
        set { self[SearchServiceKey.self] = newValue }
    }
}

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
}

class SearchService: SearchServiceType {
    private let agent: NetworkAgent
    
    init(agent: NetworkAgent) {
        self.agent = agent
    }
    
    func search(byCarPlate carPlate: String) -> AnyPublisher<CarInfo, ServiceError> {
        let request = Endpoint.search(byCarPlate: carPlate).request
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

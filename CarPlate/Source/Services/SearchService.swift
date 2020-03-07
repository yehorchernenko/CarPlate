//
//  SearchService.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 27.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation
import Combine

protocol SearchServiceType {
    func search(byCarPlate carPlate: String) -> AnyPublisher<CarInfo, Error>
}

class SearchService: SearchServiceType {
    private let agent: NetworkAgent
    
    init(agent: NetworkAgent) {
        self.agent = agent
    }
    
    func search(byCarPlate carPlate: String) -> AnyPublisher<CarInfo, Error> {
        let request = Endpoint.search(byCarPlate: carPlate).request
        return agent.run(request: request).map(\.value).eraseToAnyPublisher()
    }
}

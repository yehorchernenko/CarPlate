//
//  NetworkAgent.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 27.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation
import Combine

struct NetworkAgent {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                print(String(data: data, encoding: .utf8) ?? "")
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let value = try decoder.decode(T.self, from: data)
                return Response(value: value, response: response)
            }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

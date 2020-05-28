//
//  Endpoint.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 27.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation

enum Endpoint {
    case search(byCarPlate: String)
    case searchMany(byCarPlate: String)
    
    var urlPath: String {
        var path: String
        switch self {
        case .search:
            path = "search"

        case .searchMany:
            path = "search/all"
        }
        return basePath + path
    }
    
    var request: URLRequest {
        var urlComponents = URLComponents(string: urlPath)!
        var request: URLRequest
        switch self {
        case .search(let carPlate):
            urlComponents.queryItems = [URLQueryItem(name: "carPlate", value: carPlate)]
            request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"

        case .searchMany(let carPlate):
            urlComponents.queryItems = [URLQueryItem(name: "carPlate", value: carPlate)]
            request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"
        }
        return request
    }
    
    private var basePath: String {
        return "https://5f0a21bc7e54.ngrok.io/"
    }
}

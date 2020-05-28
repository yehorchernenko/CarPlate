//
//  Endpoint.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 27.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation

enum Endpoint {
    case searchByCarPlate(carPlate: String)
    case searchById(id: Int)
    case searchMany(byCarPlate: String)
    
    var urlPath: String {
        var path: String
        switch self {
        case .searchByCarPlate:
            path = "search"

        case .searchById(let id):
            path = "search/byId/\(id)"

        case .searchMany:
            path = "search/all"
        }
        return basePath + path
    }
    
    var request: URLRequest {
        var urlComponents = URLComponents(string: urlPath)!
        var request: URLRequest
        switch self {
        case .searchByCarPlate(let carPlate):
            urlComponents.queryItems = [URLQueryItem(name: "carPlate", value: carPlate)]
            request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"

        case .searchById:
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
        return "https://172b44e488fe.ngrok.io/"
    }
}

//
//  HelperEndpoint.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 30.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Foundation


enum HelperEndpoint {
    case policy

    var urlPath: String {
        var path = "helper/"
        switch self {
        case .policy:
            path += "policy"
        }

        return basePath + path
    }

    var request: URLRequest {
        let urlComponents = URLComponents(string: urlPath)!
        var request: URLRequest
        switch self {
        case .policy:
            request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"

            return request
        }
    }

    private var basePath: String {
        return ServerConstants.serverPath
    }
}

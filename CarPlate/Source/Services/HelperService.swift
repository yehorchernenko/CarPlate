//
//  UtilService.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 30.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Combine
import SwiftUI

protocol HelperServiceType {
    func policy() -> AnyPublisher<Policy, ServiceError>
}

class HelperService: HelperServiceType {
    private let agent: NetworkAgent

    init(agent: NetworkAgent) {
        self.agent = agent
    }

    func policy() -> AnyPublisher<Policy, ServiceError> {
        let request = HelperEndpoint.policy.request
        return agent.run(request: request).map(\.value).eraseToAnyPublisher()
    }
}

struct HelperServiceKey: EnvironmentKey {
    static var defaultValue: HelperServiceType = HelperService(agent: NetworkAgent())
}

extension EnvironmentValues {
    var helperService: HelperServiceType {
        get { self[HelperServiceKey.self] }
        set { self[HelperServiceKey.self] = newValue }
    }
}

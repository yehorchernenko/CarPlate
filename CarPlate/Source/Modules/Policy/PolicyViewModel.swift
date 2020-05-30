//
//  PolicyViewModel.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 30.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI
import Combine

class PolicyViewModel: ObservableObject {
    @Environment(\.helperService) var helperService: HelperServiceType
    @Published var request: URLRequest?
    @Published var scripts = [WebView.Script]()

    let carPlateNumber: String

    private var policyToken: Cancellable?

    init(carPlateNumber: String) {
        self.carPlateNumber = carPlateNumber
    }

    func load() {
        policyToken = helperService.policy()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    //self.toggle(error)
                    break
                case .finished:
                    break
                }
            }) { [weak self] policy in
                guard let self = self,
                    let url = URL(string: policy.webSiteURL) else {
                    //toggle error
                    return
                }
                self.request = URLRequest(url: url)
                self.scripts =
                    policy.endScripts
                        .map { WebView.Script.atEnd(script: $0)}
                +
                    policy.endScriptsWithParams
                        .map { $0.replacingOccurrences(of: "$0", with: self.carPlateNumber)}
                        .map { WebView.Script.atEnd(script: $0)}
        }
    }
}

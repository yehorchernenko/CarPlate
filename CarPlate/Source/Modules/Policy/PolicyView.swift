//
//  PolicyView.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 30.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI
import Combine

struct PolicyView: View {
    @ObservedObject var viewModel: PolicyViewModel

    var body: some View {
        ZStack {
            if viewModel.request.isNotNil {
                WebView(request: viewModel.request!, scripts: viewModel.scripts)
            }
            ActivityIndicator(isAnimating: .constant(viewModel.request.isNil))
        }.onAppear {
            self.viewModel.load()
        }
    }
}

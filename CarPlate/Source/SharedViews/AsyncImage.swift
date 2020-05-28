//
//  AsyncImage.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 23.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI
import Foundation
import Combine

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    var configuration: (Image) -> AnyView

    init(url: URL?, placeholder: Placeholder? = nil, cache: ImageCache? = nil, configuration: @escaping (Image) -> AnyView = { AnyView($0) }) {
        loader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
        loader.load()
    }

    var body: some View {
        image
    }

    private var image: some View {
        Group {
            if loader.image.isNil {
                placeholder
            } else {
                configuration(Image(uiImage: loader.image!))
            }
        }
    }
}


//
//  ActivityIndicator.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 01.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI
import UIKit

struct ActivityIndicator: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView
    @Binding var isAnimating: Bool
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        isAnimating ? indicator.startAnimating() : indicator.stopAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActivityIndicator(isAnimating: .constant(true)).previewLayout(.fixed(width: 350, height: 50))
            ActivityIndicator(isAnimating: .constant(false)).previewLayout(.fixed(width: 350, height: 50))
        }
    }
}

//
//  UIApplication+Ext.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 07.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import UIKit
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct OnAppearDismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content.onAppear {
            UIApplication.shared.endEditing()
        }
    }
}

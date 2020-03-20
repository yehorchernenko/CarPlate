//
//  CarPlateRecognitionView.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 07.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI
import UIKit

struct CarPlateRecognitionView: View {
    
    var body: some View {
        CarPlateViewControllerRepresentation()
    }
}

struct CarplateRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        CarPlateRecognitionView()
    }
}


struct CarPlateViewControllerRepresentation: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: CarPlateRecognitionViewController, context: UIViewControllerRepresentableContext<CarPlateViewControllerRepresentation>) {
        
    }
    
    func makeUIViewController(context: Context) -> CarPlateRecognitionViewController {
        let sb = UIStoryboard(name: String(describing: CarPlateRecognitionViewController.self), bundle: nil)
        let controller = sb.instantiateInitialViewController() as! CarPlateRecognitionViewController
        
        return controller
    }
    
}

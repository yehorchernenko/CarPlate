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
    @Binding var image: UIImage?
    @State var recognizedText = "Recognizing…"
    
    var body: some View {
        CarPlateViewControllerRepresentation(image: $image, recognizedText: $recognizedText)
            .navigationBarTitle(recognizedText)
    }
}

struct CarplateRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        CarPlateRecognitionView(image: .constant(UIImage()))
    }
}


struct CarPlateViewControllerRepresentation: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var recognizedText: String

    func updateUIViewController(_ uiViewController: CarPlateRecognitionViewController, context: UIViewControllerRepresentableContext<CarPlateViewControllerRepresentation>) {
        
    }
    
    func makeUIViewController(context: Context) -> CarPlateRecognitionViewController {
        let recognitionSb = UIStoryboard(name: String(describing: CarPlateRecognitionViewController.self), bundle: nil)

        let recognitionController = recognitionSb.instantiateInitialViewController() as! CarPlateRecognitionViewController
        let recognitionViewModel = CarPlateRecognitionViewModel(image: image!, recognizedText: $recognizedText, onTextRecognized: { _ in })
        recognitionController.viewModel = recognitionViewModel
        
        return recognitionController
    }
    
}

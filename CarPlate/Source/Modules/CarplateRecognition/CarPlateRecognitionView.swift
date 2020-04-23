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

    func updateUIViewController(_ uiViewController: CarPlateRecognitionContainerViewController, context: UIViewControllerRepresentableContext<CarPlateViewControllerRepresentation>) {
        
    }
    
    func makeUIViewController(context: Context) -> CarPlateRecognitionContainerViewController {
        let containerSb = UIStoryboard(name: String(describing: CarPlateRecognitionContainerViewController.self), bundle: nil)
        let containerController = containerSb.instantiateInitialViewController() as! CarPlateRecognitionContainerViewController
        let recognitionSb = UIStoryboard(name: String(describing: CarPlateRecognitionViewController.self), bundle: nil)

        let detailsViewModel = CarDetailsViewModel(recognizedText: $recognizedText)
        let detailsView = CarDetailsView(viewModel: detailsViewModel)
        let detailsViewController = UIHostingController(rootView: detailsView)

        let recognitionController = recognitionSb.instantiateInitialViewController() as! CarPlateRecognitionViewController
        let recognitionViewModel = CarPlateRecognitionViewModel(image: image!, recognizedText: $recognizedText, onTextRecognized: detailsViewModel.didUpdateSearchText)
        recognitionController.viewModel = recognitionViewModel

        containerController.recognitionViewController = recognitionController
        containerController.detailInfoViewController = detailsViewController
        
        return containerController
    }
    
}

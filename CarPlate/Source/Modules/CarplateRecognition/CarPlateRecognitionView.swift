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
    
    var body: some View {
        CarPlateViewControllerRepresentation(image: $image)
    }
}

struct CarplateRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        CarPlateRecognitionView(image: .constant(UIImage()))
    }
}


struct CarPlateViewControllerRepresentation: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func updateUIViewController(_ uiViewController: CarPlateRecognitionContainerViewController, context: UIViewControllerRepresentableContext<CarPlateViewControllerRepresentation>) {
        
    }
    
    func makeUIViewController(context: Context) -> CarPlateRecognitionContainerViewController {
        let containerSb = UIStoryboard(name: String(describing: CarPlateRecognitionContainerViewController.self), bundle: nil)
        let containerController = containerSb.instantiateInitialViewController() as! CarPlateRecognitionContainerViewController

        let recognitionSb = UIStoryboard(name: String(describing: CarPlateRecognitionViewController.self), bundle: nil)
        let recognitionController = recognitionSb.instantiateInitialViewController() as! CarPlateRecognitionViewController
        recognitionController.viewModel = CarPlateRecognitionViewModel(image: image!)

        let detailsView = CarDetailsView(details: .fake)
        let detailsViewController = UIHostingController(rootView: detailsView)

        containerController.recognitionViewController = recognitionController
        containerController.detailInfoViewController = detailsViewController
        
        return containerController
    }
    
}

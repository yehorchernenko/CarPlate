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
    @State var navigationTitle = "Recognizing…"
    
    var body: some View {
        CarPlateViewControllerRepresentation(image: $image, navigationTitle: $navigationTitle)
            .navigationBarTitle(navigationTitle)
    }
}

struct CarplateRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        CarPlateRecognitionView(image: .constant(UIImage()))
    }
}


struct CarPlateViewControllerRepresentation: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var navigationTitle: String

    func updateUIViewController(_ uiViewController: CarPlateRecognitionContainerViewController, context: UIViewControllerRepresentableContext<CarPlateViewControllerRepresentation>) {
        
    }
    
    func makeUIViewController(context: Context) -> CarPlateRecognitionContainerViewController {
        let containerSb = UIStoryboard(name: String(describing: CarPlateRecognitionContainerViewController.self), bundle: nil)
        let containerController = containerSb.instantiateInitialViewController() as! CarPlateRecognitionContainerViewController

        let recognitionSb = UIStoryboard(name: String(describing: CarPlateRecognitionViewController.self), bundle: nil)
        let recognitionController = recognitionSb.instantiateInitialViewController() as! CarPlateRecognitionViewController
        recognitionController.viewModel = CarPlateRecognitionViewModel(image: image!, navigationTitle: $navigationTitle)

        let detailsView = CarDetailsView(details: .fake)
        let detailsViewController = UIHostingController(rootView: detailsView)

        containerController.recognitionViewController = recognitionController
        containerController.detailInfoViewController = detailsViewController
        
        return containerController
    }
    
}

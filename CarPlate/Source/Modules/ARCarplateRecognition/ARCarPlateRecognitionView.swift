//
//  ARCarPlateRecognitionView.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 26.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI

struct ARCarPlateRecognitionView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> ARCarPlateRecognitionViewController {
        let sb = UIStoryboard(name: String(describing: ARCarPlateRecognitionViewController.self), bundle: nil)
        let controller = sb.instantiateInitialViewController() as! ARCarPlateRecognitionViewController

        return controller
    }

    func updateUIViewController(_ uiViewController: ARCarPlateRecognitionViewController, context: Context) {

    }
    
}

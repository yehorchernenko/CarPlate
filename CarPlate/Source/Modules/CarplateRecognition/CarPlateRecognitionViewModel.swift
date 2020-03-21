//
//  CarPlateRecognitionViewModel.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 21.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import UIKit
import Vision
import CoreML

class CarPlateRecognitionViewModel {
    let service: ObjectDetectionServiceType = ObjectDetectionService()

    func recognize(on image: UIImage, completion: @escaping ([VNRecognizedObjectObservation]) -> Void) {
        service.detect(on: image) { result in
            switch result {
            case .success(let recognizedObjects):
                completion(recognizedObjects)

            case .failure(let error):
                completion([])
            }
        }
    }
}

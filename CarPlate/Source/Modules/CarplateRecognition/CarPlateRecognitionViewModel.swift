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
    let objectDetectionService: ObjectDetectionServiceType = ObjectDetectionService()
    let ocrService: OCRServiceType = OCRService(postProcessor: CarPlateOCRPostProcessor())

    func detect(on image: UIImage, completion: @escaping ([VNRecognizedObjectObservation]) -> Void) {
        objectDetectionService.detect(on: image) { result in
            switch result {
            case .success(let recognizedObjects):
                completion(recognizedObjects)

            case .failure(let error):
                completion([])
            }
        }
    }

    func ocr(on image: UIImage, completion: @escaping ([String]) -> Void) {
        ocrService.recognize(on: image) { result in
            switch result {
            case .success(let recognizedTexts):
                completion(recognizedTexts)

            case .failure(let error):
                completion([])
            }
        }
    }
}

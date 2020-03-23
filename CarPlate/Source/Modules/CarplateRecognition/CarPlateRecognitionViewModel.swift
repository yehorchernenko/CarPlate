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
    enum State {
        case idle
        case viewDidSetup(image: UIImage)
        case didRecognizeCarPlate(boundingBox: CGRect)
        case didOCR(text: String)
        case didReceiveError(message: String)
    }
    let objectDetectionService: ObjectDetectionServiceType = ObjectDetectionService()
    let ocrService: OCRServiceType = OCRService(postProcessor: CarPlateOCRPostProcessor())
    let image: UIImage
    @Published var state: State = .idle

    init(image: UIImage) {
        self.image = image
    }

    func viewDidSetup() {
        state = .viewDidSetup(image: image)

        objectDetectionService.detect(on: image, completion: didDetectHandler)
    }

    func didDetectHandler(_ result: Result<[CGRect], Error>) {
        switch result {
        case .success(let boundingBoxes):
            guard let boundingBox = boundingBoxes.first else {
                assertionFailure("TODO")
                return
            }
            state = .didRecognizeCarPlate(boundingBox: boundingBox)

        case .failure(let error):
            assertionFailure("TODO")
        }
    }

    func detect(on image: UIImage, completion: @escaping ([VNRecognizedObjectObservation]) -> Void) {
//        objectDetectionService.detect(on: image) { result in
//            switch result {
//            case .success(let recognizedObjects):
//                completion(recognizedObjects)
//
//            case .failure(let error):
//                completion([])
//            }
//        }
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

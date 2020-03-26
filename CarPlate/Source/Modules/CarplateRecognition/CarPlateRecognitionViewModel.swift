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
import Combine
import SwiftUI

class CarPlateRecognitionViewModel {
    enum State {
        case processing
        case showBackgroundImage(image: UIImage)
        case addDrawingLayer(normalizedImage: UIImage)
        case highlightRecognizedCarPlateRect(boundingBox: CGRect)
        case showRecognizedCarPlateImage(image: UIImage)
        case showRecognizedText(text: String)
        case didReceiveError(message: String)
    }
    let objectRecognitionService: ObjectRecognitionServiceType = ObjectRecognitionService()
    let ocrService: OCRServiceType = OCRService(postProcessor: CarPlateOCRPostProcessor())
    let image: UIImage
    var normalizedImage: UIImage!
    @Published var state: State = .processing
    @Binding var navigationTitle: String
    
    init(image: UIImage, navigationTitle: Binding<String>) {
        self.image = image
        _navigationTitle = navigationTitle
    }

    func viewDidLoad() {
        //in order to set blurred background
        state = .showBackgroundImage(image: image)
        normalizedImage = image.scaledAndOriented(maxResolution: 640)
    }

    func viewDidAppear() {
        state = .addDrawingLayer(normalizedImage: normalizedImage)

        startCarPlateRecognition()
    }

    func startCarPlateRecognition() {
        objectRecognitionService.detect(on: normalizedImage, completion: didRecognizeHandler)
    }

    func didRecognizeHandler(_ result: Result<[CGRect], Error>) {
        switch result {
        case .success(let boundingBoxes):
            guard let boundingBox = boundingBoxes.first else {
                assertionFailure("TODO")
                return
            }
            state = .highlightRecognizedCarPlateRect(boundingBox: boundingBox)

            let recognizedImage = imageOnRecognizedRect(boundingBox)
            state = .showRecognizedCarPlateImage(image: recognizedImage)

            startOCR(on: recognizedImage)


        case .failure(let error):
            state = .didReceiveError(message: error.localizedDescription)
        }
    }

    func imageOnRecognizedRect(_ rect: CGRect) -> UIImage {
        let rectOfInterest = normalizedImage.normalizedRect(forRegionOfInterest: rect)
        guard let image = normalizedImage.cropped(to: rectOfInterest) else {
            return UIImage ()
        }
        return image
    }

    func startOCR(on image: UIImage) {
        ocrService.recognize(on: image, completion: didOCRHandler(_:))
    }

    func didOCRHandler(_ result: Result<[String], Error>) {
        switch result {
        case .success(let texts):
            guard let text = texts.first else { return }
            state = .showRecognizedText(text: text)
            navigationTitle = text

        case .failure(let error):
            state = .didReceiveError(message: error.localizedDescription)
        }
    }
}

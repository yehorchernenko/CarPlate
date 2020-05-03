//
//  OCRService.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 21.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import UIKit
import Vision

protocol OCRServiceType {
    func recognize(on image: UIImage, completion: @escaping (Result<[String], Error>) -> Void)
}

class OCRService: OCRServiceType {
    enum OCRError: Error {
        case requestIsNil
        case cgImageIsNil
    }

    lazy var textRecognitionRequest: VNRecognizeTextRequest = {
        let textRecognitionRequest = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
        textRecognitionRequest.recognitionLanguages = ["en-US"] //language ISO code
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.minimumTextHeight = 0.3
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesCPUOnly = false //better to use in real time request

        return textRecognitionRequest
    }()

    var postProcessor: OCRPostProcessor
    var completion: ((Result<[String], Error>) -> Void)?

    init(postProcessor: OCRPostProcessor) {
        self.postProcessor = postProcessor
    }

    func recognize(on image: UIImage, completion: @escaping (Result<[String], Error>) -> Void) {
        self.completion = completion

        // Convert from UIImageOrientation to CGImagePropertyOrientation.
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let cgImage = image.cgImage else {
            completion(.failure(OCRError.cgImageIsNil))
            return
        }

        performRecognition(request: textRecognitionRequest, image: cgImage, orientation: cgOrientation)
    }

    func performRecognition(request: VNRequest, image: CGImage, orientation: CGImagePropertyOrientation) {
        // Create a request handler.
        let imageRequestHandler = VNImageRequestHandler(cgImage: image,
                                                        orientation: orientation,
                                                        options: [:])

        // Send the requests to the request handler.
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform([request])
            } catch {
                self.complete(.failure(error))
                return
            }
        }
    }

    fileprivate func handleDetectedText(request: VNRequest?, error: Error?) {
        if let error = error {
            complete(.failure(error))
            return
        }

        guard let request = request, let results = request.results as? [VNRecognizedTextObservation] else {
            complete(.failure(OCRError.requestIsNil))
            return
        }

        complete(.success(postProcessor.process(results: results)))
    }

    func complete(_ result: Result<[String], Error>) {
        DispatchQueue.main.async {
            self.completion?(result)
        }
    }
}

//
//  ObjectDetectionService.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 21.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import UIKit
import Vision
import CoreML

protocol ObjectDetectionServiceType {
    func detect(on image: UIImage, completion: @escaping (Result<[CGRect], Error>) -> Void)
}

class ObjectDetectionService: ObjectDetectionServiceType {
    lazy var coreMLRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: CarPlateDetector().model)
            let request = VNCoreMLRequest(model: model, completionHandler: self.coreMlRequestHandler)

            return request
        } catch {
            complete(.failure(RecognitionError.unableToInitializeCoreMLModel))
            fatalError()
        }
    }()

    var completion: ((Result<[CGRect], Error>) -> Void)?

    func detect(on image: UIImage, completion: @escaping (Result<[CGRect], Error>) -> Void) {
        self.completion = completion

        // Convert from UIImageOrientation to CGImagePropertyOrientation.
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let cgImage = image.cgImage else {
            complete(.failure(RecognitionError.cgImageIsNil))
            return
        }

        performRecognition(request: coreMLRequest, image: cgImage, orientation: cgOrientation)
    }
}

private extension ObjectDetectionService {
    enum RecognitionError: Error {
        case cgImageIsNil
        case unableToInitializeCoreMLModel
        case requestIsNil
        case lowConfidence
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

    func coreMlRequestHandler(_ request: VNRequest?, error: Error?) {
        if let error = error {
            complete(.failure(error))
            return
        }

        guard let request = request, let results = request.results as? [VNRecognizedObjectObservation] else {
            complete(.failure(RecognitionError.requestIsNil))
            return
        }

        let highConfidenceResults = results
            .filter { $0.confidence > 0.7 }
            .sorted { $0.confidence > $1.confidence }

        if highConfidenceResults.isEmpty {
            complete(.failure(RecognitionError.lowConfidence))
        } else {
            complete(.success(highConfidenceResults))
        }
    }

    func complete(_ result: Result<[VNRecognizedObjectObservation], Error>) {
        DispatchQueue.main.async {
            self.completion?(result.map { $0.map { $0.boundingBox } })
        }
    }
}

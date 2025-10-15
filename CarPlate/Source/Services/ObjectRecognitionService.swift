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

protocol ObjectRecognitionServiceType {
    func detect(on image: UIImage, completion: @escaping (Result<[CGRect], Error>) -> Void)
}

class ObjectRecognitionService: ObjectRecognitionServiceType {
    // Improved model loading with proper error handling
    private static func loadModel() -> VNCoreMLModel? {
        do {
            let modelConfig = MLModelConfiguration()
            modelConfig.computeUnits = .all // Use all available compute units (CPU, GPU, Neural Engine)
            
            let model = try CarPlateDetector(configuration: modelConfig).model
            let visionModel = try VNCoreMLModel(for: model)
            return visionModel
        } catch {
            print("❌ Failed to load CarPlateDetector model: \(error)")
            print("Model error details: \(error.localizedDescription)")
            return nil
        }
    }
    
    static let carPlateModel = loadModel()

    var completion: ((Result<[CGRect], Error>) -> Void)?

    func detect(on image: UIImage, completion: @escaping (Result<[CGRect], Error>) -> Void) {
        self.completion = completion
        
        // Check if model is loaded
        guard let model = ObjectRecognitionService.carPlateModel else {
            complete(.failure(RecognitionError.unableToInitializeCoreMLModel))
            return
        }

        // Convert from UIImageOrientation to CGImagePropertyOrientation.
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let cgImage = image.cgImage else {
            complete(.failure(RecognitionError.cgImageIsNil))
            return
        }
        
        // Create request each time to avoid state issues
        let request = VNCoreMLRequest(model: model, completionHandler: self.coreMlRequestHandler)
        request.imageCropAndScaleOption = .centerCrop

        performRecognition(request: request, image: cgImage, orientation: cgOrientation)
    }
}

private extension ObjectRecognitionService {
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
            print("❌ CoreML Request Error: \(error)")
            complete(.failure(error))
            return
        }

        guard let request = request else {
            print("❌ Request is nil")
            complete(.failure(RecognitionError.requestIsNil))
            return
        }
        
        print("📊 Request results count: \(request.results?.count ?? 0)")
        print("📊 Request results type: \(type(of: request.results))")
        
        guard let results = request.results as? [VNRecognizedObjectObservation] else {
            print("❌ Results cannot be cast to [VNRecognizedObjectObservation]")
            print("   Actual results: \(String(describing: request.results))")
            complete(.failure(RecognitionError.requestIsNil))
            return
        }
        
        print("✅ Found \(results.count) raw results")
        results.forEach { result in
            print("   - Confidence: \(result.confidence), Labels: \(result.labels.map { "\($0.identifier): \($0.confidence)" })")
        }

        // Lowered threshold to 0.3 for better detection
        let highConfidenceResults = results
            .filter { $0.confidence > 0.3 }
            .sorted { $0.confidence > $1.confidence }

        print("✅ Found \(highConfidenceResults.count) results after filtering (confidence > 0.3)")

        if highConfidenceResults.isEmpty {
            print("❌ No high confidence results found (all below 0.3)")
            complete(.failure(RecognitionError.lowConfidence))
        } else {
            print("✅ Returning \(highConfidenceResults.count) results")
            complete(.success(highConfidenceResults))
        }
    }

    func complete(_ result: Result<[VNRecognizedObjectObservation], Error>) {
        DispatchQueue.main.async {
            self.completion?(result.map { $0.map { $0.boundingBox } })
        }
    }
}

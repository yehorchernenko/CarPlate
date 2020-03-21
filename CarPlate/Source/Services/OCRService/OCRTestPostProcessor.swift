//
//  OCRTestPostProcessor.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 21.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Vision

protocol OCRTestPostProcessor {
    func process(results: [VNRecognizedTextObservation]) -> [String]
}

class CarPlateOCRPostProcessor: OCRTestPostProcessor {
    func process(results: [VNRecognizedTextObservation]) -> [String] {
        return results.compactMap { $0.topCandidates(1).first?.string }
    }
}

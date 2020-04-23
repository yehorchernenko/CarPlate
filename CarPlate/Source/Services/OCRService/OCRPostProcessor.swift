//
//  OCRTestPostProcessor.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 21.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import Vision

protocol OCRPostProcessor {
    func process(results: [VNRecognizedTextObservation]) -> [String]
}

class CarPlateOCRPostProcessor: OCRPostProcessor {
    func process(results: [VNRecognizedTextObservation]) -> [String] {
        results.forEach { res in res.topCandidates(.max).forEach { text in
            text.string.forEach { char in
                print(char.asciiValue)
                char.unicodeScalars.forEach { print($0.value)}
            }

            }
        }
        return results.compactMap {
            guard let string = $0.topCandidates(1).first?.string else {
                return nil
            }

            return string
                .components(separatedBy: .whitespaces).joined()
                .components(separatedBy: .punctuationCharacters).joined()
        }
    }


}

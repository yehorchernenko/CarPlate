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
        return results.compactMap {
            guard let string = $0.topCandidates(1).first?.string else { return nil }

            let punctuationFreeString = string
                .components(separatedBy: .whitespacesAndNewlines).joined()
                .components(separatedBy: .punctuationCharacters).joined()

            guard punctuationFreeString.count == 8 else { return nil }

            let secondCharIndex = punctuationFreeString.index(after: punctuationFreeString.startIndex)
            let city = punctuationFreeString[punctuationFreeString.startIndex...secondCharIndex]

            let beforeLastIndex = punctuationFreeString.index(before: punctuationFreeString.index(before: punctuationFreeString.endIndex))
            let serial = punctuationFreeString[beforeLastIndex..<punctuationFreeString.endIndex]

            print("Original string: \(punctuationFreeString)")

            let mappedCity = mapToCyrillic(String(city))
            let mappedSerial = mapToCyrillic(String(serial))

            let updatedString = punctuationFreeString
                .replacingOccurrences(of: city, with: mappedCity)
                .replacingOccurrences(of: serial, with: mappedSerial)
            print("Updated string: \(updatedString)")

            return updatedString
        }
    }

    private func mapToCyrillic(_ string: String) -> String {
        guard string.count == 2 else {
            assertionFailure("More than to chars to adjust")
            return string
        }

        guard let firstChar = string.first, let firstMappedChar = cyrillicCharacters[String(firstChar)] else {
            assertionFailure("Mapping failure")
            return string
        }

        guard let lastChar = string.last, let secondMappedChar = cyrillicCharacters[String(lastChar)] else {
            assertionFailure("Mapping failure")
            return string
        }

        return firstMappedChar + secondMappedChar
    }

    private let cyrillicCharacters: [String: String] = [
        "A": "А",
        "B": "В",
        "C": "С",
        "D": "Д",
        "E": "Е",
        "F": "Е",
        "G": "А",
        "H": "Н",
        "I": "І",
        "K": "К",
        "L": "Л",
        "M": "М",
        "N": "Л",
        "O": "О",
        "P": "Р",
        "Q": "Ц",
        "R": "Р",
        "S": "С",
        "T": "Т",
        "V": "В",
        "X": "Х",
        "Y": "У",
        "Z": "Я",
        //numbers
        "4": "А",
        "1": "І",
        "0": "С"
    ]

}

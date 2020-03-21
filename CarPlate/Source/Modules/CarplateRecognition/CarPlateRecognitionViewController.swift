/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Contains the main app implementation using Vision.
*/

import Photos
import UIKit
import Vision
import CoreML
import Foundation

class CarPlateRecognitionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let viewModel = CarPlateRecognitionViewModel()

    @IBOutlet weak var recognizedTextLabel: UILabel!
    @IBOutlet weak var recognizedObjectImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    var originalImage: UIImage?
    
    // Layer into which to draw bounding box paths.
    var pathLayer: CALayer?
    
    // Image parameters for reuse throughout app
    var imageWidth: CGFloat = 0
    var imageHeight: CGFloat = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let originalImage = originalImage else {
            return
        }
        // Display image on screen.
        show(originalImage)

//        // Convert from UIImageOrientation to CGImagePropertyOrientation.
//        let cgOrientation = CGImagePropertyOrientation(originalImage.imageOrientation)
//
//        // Fire off request based on URL of chosen photo.
//        guard let cgImage = originalImage.cgImage else {
//            return
//        }
        //performVisionRequest(coreMLRequest, image: cgImage, orientation: cgOrientation)
        viewModel.recognize(on: originalImage) { [weak self] recognizedObjects in
            self?.onObjectsRecognized(recognizedObjects)
        }

    }

    /// - Tag: PreprocessImage
    func show(_ image: UIImage) {
        
        // Remove previous paths & image
        pathLayer?.removeFromSuperlayer()
        pathLayer = nil
        imageView.image = nil
        
        // Account for image orientation by transforming view.
        let correctedImage = image.scaledAndOriented(maxResolution: 640)
        
        // Place photo inside imageView.
        imageView.image = correctedImage
        
        // Transform image to fit screen.
        guard let cgImage = correctedImage.cgImage else {
            print("Trying to show an image not backed by CGImage!")
            return
        }
        
        let fullImageWidth = CGFloat(cgImage.width)
        let fullImageHeight = CGFloat(cgImage.height)
        
        let imageFrame = imageView.frame
        let widthRatio = fullImageWidth / imageFrame.width
        let heightRatio = fullImageHeight / imageFrame.height
        
        // ScaleAspectFit: The image will be scaled down according to the stricter dimension.
        let scaleDownRatio = max(widthRatio, heightRatio)
        
        // Cache image dimensions to reference when drawing CALayer paths.
        imageWidth = fullImageWidth / scaleDownRatio
        imageHeight = fullImageHeight / scaleDownRatio
        
        // Prepare pathLayer to hold Vision results.
        let xLayer = (imageFrame.width - imageWidth) / 2
        let yLayer = imageView.frame.minY + (imageFrame.height - imageHeight) / 2
        let drawingLayer = CALayer()
        drawingLayer.bounds = CGRect(x: xLayer, y: yLayer, width: imageWidth, height: imageHeight)
        drawingLayer.anchorPoint = CGPoint.zero
        drawingLayer.position = CGPoint(x: xLayer, y: yLayer)
        drawingLayer.opacity = 0.5
        drawingLayer.borderColor = UIColor.red.cgColor
        drawingLayer.borderWidth = 2
        pathLayer = drawingLayer
        self.view.layer.addSublayer(pathLayer!)
    }
    
    // MARK: - Vision
    
    /// - Tag: PerformRequests
    fileprivate func performVisionRequest(_ request: VNRequest, image: CGImage, orientation: CGImagePropertyOrientation) {
        
        // Create a request handler.
        let imageRequestHandler = VNImageRequestHandler(cgImage: image,
                                                        orientation: orientation,
                                                        options: [:])
        
        // Send the requests to the request handler.
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform([request])
            } catch let error as NSError {
                print("Failed to perform image request: \(error)")
                self.presentAlert("Image Request Failed", error: error)
                return
            }
        }
    }
    
    fileprivate func handleCoreMLRequest(request: VNRequest?, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request?.results as? [VNRecognizedObjectObservation] else {
                print(error!.localizedDescription)
                return
            }
            results.forEach { print($0.confidence)}
            self.onObjectsRecognized(results.filter { $0.confidence > 0.7 })
        }
    }
    
    fileprivate func handleDetectedText(request: VNRequest?, error: Error?) {
        if let nsError = error as NSError? {
            self.presentAlert("Text Detection Error", error: nsError)
            return
        }
        // Perform drawing on the main thread.
        DispatchQueue.main.async {
            guard let results = request?.results as? [VNRecognizedTextObservation] else {
                    return
            }
            
            results.forEach {
                let text = $0.topCandidates(1).first?.string ?? ""
                let formattedText = text.trimmingCharacters(in: .whitespaces)
                self.recognizedTextLabel.text = formattedText
            }
        }
    }
    
    func onObjectsRecognized(_ recognizedObjects: [VNRecognizedObjectObservation]) {
        //draw path and set recognized image
        guard let drawLayer = self.pathLayer else { fatalError() }
        draw(objects: recognizedObjects, onImageWithBounds: drawLayer.bounds)
        drawLayer.setNeedsDisplay()

        guard let recognizedObjectImage = recognizedObjectImageView.image,
            let recognizedObjectCGImage = recognizedObjectImage.cgImage else { fatalError() }
        let orientation = CGImagePropertyOrientation(recognizedObjectImage.imageOrientation)
        performVisionRequest(textRecognitionRequest, image: recognizedObjectCGImage, orientation: orientation)
    }
    
    /// - Tag: ConfigureCompletionHandler
    
    lazy var coreMLRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: CarPlateDetector().model)
            let request = VNCoreMLRequest(model: model, completionHandler: self.handleCoreMLRequest)
            
            return request
        } catch {
            fatalError()
        }
    }()
    
    lazy var textRecognitionRequest: VNRecognizeTextRequest = {
        let textRecognitionRequest = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.recognitionLanguages = ["ukr"] //language ISO code
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.recognitionLevel = .fast
        textRecognitionRequest.usesCPUOnly = true //better to use in real time request
        
        return textRecognitionRequest
    }()
    
    // MARK: - Path-Drawing
    
    fileprivate func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
        
        let imageWidth = bounds.width
        let imageHeight = bounds.height
        
        // Begin with input rect.
        var rect = forRegionOfInterest
        
        // Reposition origin.
        rect.origin.x *= imageWidth
        rect.origin.x += bounds.origin.x
        rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y
        
        // Rescale normalized coordinates.
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight
        
        return rect
    }
    
    fileprivate func normalizedRect(forRegionOfInterest: CGRect, originalImage: CGImage) -> CGRect {
        let originalImageWidth = CGFloat(originalImage.width)
        let originalImageHeight = CGFloat(originalImage.height)
        // Begin with input rect.
        var rect = forRegionOfInterest
        
        // Reposition origin.
        rect.origin.x *= originalImageWidth
        rect.origin.y =  (1 - rect.origin.y - rect.size.height) * originalImageHeight
        
        // Rescale normalized coordinates.
        rect.size.width *= originalImageWidth
        rect.size.height *= originalImageHeight
        
        return rect
    }
    
    func maximumContrast(cgImage: CGImage) -> CGImage? {
        let ciImage = CIImage(cgImage: cgImage)
        let parameters = ["inputSaturation": NSNumber(value: 0), "inputContrast": NSNumber(value: 5)]
        let contrastedImage = ciImage.applyingFilter("CIColorControls", parameters: parameters)
        let context = CIContext(options: nil)
        return context.createCGImage(contrastedImage, from: contrastedImage.extent)
    }
    
    fileprivate func shapeLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {
        // Create a new layer.
        let layer = CAShapeLayer()
        
        // Configure layer's appearance.
        layer.fillColor = nil // No fill to show boxed object
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.borderWidth = 2
        
        // Vary the line color according to input.
        layer.borderColor = color.cgColor
        
        // Locate the layer.
        layer.anchorPoint = .zero
        layer.frame = frame
        layer.masksToBounds = true
        
        // Transform the layer to have same coordinate system as the imageView underneath it.
        layer.transform = CATransform3DMakeScale(1, -1, 1)
        
        return layer
    }
    
    fileprivate func draw(objects: [VNRecognizedObjectObservation], onImageWithBounds bounds: CGRect) {
        CATransaction.begin()
        for observation in objects {
            guard let originalImage = imageView.image?.cgImage else { fatalError() }
            let rect = normalizedRect(forRegionOfInterest: observation.boundingBox, originalImage: originalImage)
            
            guard let recognizedImage = originalImage.cropping(to: rect) else { fatalError() }
            //let contrastedImage = maximumContrast(cgImage: recognizedImage)
            recognizedObjectImageView.image = UIImage(cgImage: recognizedImage)
            
            let rectBox = boundingBox(forRegionOfInterest: observation.boundingBox, withinImageBounds: bounds)
            let rectLayer = shapeLayer(color: .green, frame: rectBox)
            
            // Add to pathLayer on top of image.
            pathLayer?.addSublayer(rectLayer)
            
        }
        CATransaction.commit()
    }


    // MARK: - Helper Methods

    func presentAlert(_ title: String, error: NSError) {
        // Always present alert on main thread.
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title,
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default) { _ in
                                            // Do nothing -- simply dismiss alert.
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

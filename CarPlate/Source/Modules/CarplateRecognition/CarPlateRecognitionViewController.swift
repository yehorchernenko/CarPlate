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
import Combine

class CarPlateRecognitionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    lazy var viewModel = CarPlateRecognitionViewModel(image: self.originalImage!)
    private var bindings = Set<AnyCancellable>()

    @IBOutlet weak var recognizedTextLabel: UILabel!
    @IBOutlet weak var recognizedObjectImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    var originalImage: UIImage?
    
    // Layer into which to draw bounding box paths.
    var pathLayer: CALayer?
    
    // Image parameters for reuse throughout app
    var imageWidth: CGFloat = 0
    var imageHeight: CGFloat = 0

    func didUpdateViewModelStateHandler(_ state: CarPlateRecognitionViewModel.State) {
        switch state {
        case .processing:
            break

        case .showBackgroundImage(let image):
            break

        case .addDrawingLayer(let normalizedImage):
            imageView.image = normalizedImage
            addDrawingLayer(normalizedImage: normalizedImage)

        case .showRecognizedCarPlateImage(let image):
            recognizedObjectImageView.image = image

        case .highlightRecognizedCarPlateRect(let boundingBox):
            onObjectRecognized(rectOfRecognition: boundingBox)

        case .showRecognizedText(let text):
            recognizedTextLabel.text = text

        case .didReceiveError(let message):
            assertionFailure("Error message: \(message)")

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: didUpdateViewModelStateHandler(_:))
            .store(in: &bindings)


        viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.viewDidAppear()
    }

    /// - Tag: PreprocessImage
    func addDrawingLayer(normalizedImage image: UIImage) {
        // Transform image to fit screen.
        guard let cgImage = image.cgImage else {
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

    func onObjectRecognized(rectOfRecognition: CGRect) {
        //draw path and set recognized image
        guard let drawLayer = self.pathLayer else { fatalError() }
        draw(rectOfRecognition: rectOfRecognition, onImageWithBounds: drawLayer.bounds)
        drawLayer.setNeedsDisplay()

//        guard let recognizedObjectImage = recognizedObjectImageView.image else { fatalError() }
//
//        viewModel.ocr(on: recognizedObjectImage) { [weak self] texts in
//            self?.recognizedTextLabel.text = texts.first ?? ""
//        }
    }
    
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
    
    fileprivate func draw(rectOfRecognition: CGRect, onImageWithBounds bounds: CGRect) {
        CATransaction.begin()
//        guard let originalImage = imageView.image?.cgImage else { fatalError() }
//        let rect = normalizedRect(forRegionOfInterest: rectOfRecognition, originalImage: originalImage)
//
//        guard let recognizedImage = originalImage.cropping(to: rect) else { fatalError() }
//        recognizedObjectImageView.image = UIImage(cgImage: recognizedImage)

        let rectBox = boundingBox(forRegionOfInterest: rectOfRecognition, withinImageBounds: bounds)
        let rectLayer = shapeLayer(color: .green, frame: rectBox)

        // Add to pathLayer on top of image.
        pathLayer?.addSublayer(rectLayer)

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

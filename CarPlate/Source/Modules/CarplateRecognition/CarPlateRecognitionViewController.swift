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
    var viewModel: CarPlateRecognitionViewModel!
    private var bindings = Set<AnyCancellable>()

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var blurImageView: UIImageView!
    @IBOutlet weak var recognizedTextLabel: UILabel!
    @IBOutlet weak var recognizedObjectImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    // Layer into which to draw bounding box paths.
    var pathLayer: CALayer?


    func didUpdateViewModelStateHandler(_ state: CarPlateRecognitionViewModel.State) {
        switch state {
        case .processing:
            spinner.startAnimating()

        case .showBackgroundImage(let image):
            blurImageView.image = image

        case .addDrawingLayer(let normalizedImage):
            imageView.image = normalizedImage
            addDrawingLayer(normalizedImage: normalizedImage)

        case .showRecognizedCarPlateImage(let image):
            recognizedObjectImageView.image = image

        case .highlightRecognizedCarPlateRect(let boundingBox):
            highlightRecognized(rectOfInterest: boundingBox)

        case .showRecognizedText(let text):
            recognizedTextLabel.text = text
            spinner.stopAnimating()

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
        let imageWidth = fullImageWidth / scaleDownRatio
        let imageHeight = fullImageHeight / scaleDownRatio
        
        // Prepare pathLayer to hold Vision results.
        let xLayer = (imageFrame.width - imageWidth) / 2
        let yLayer = imageView.frame.minY + (imageFrame.height - imageHeight) / 2
        let drawingLayer = CALayer()
        drawingLayer.bounds = CGRect(x: xLayer, y: yLayer, width: imageWidth, height: imageHeight)
        drawingLayer.anchorPoint = CGPoint.zero
        drawingLayer.position = CGPoint(x: xLayer, y: yLayer)
        drawingLayer.opacity = 1
        pathLayer = drawingLayer
        self.view.layer.addSublayer(drawingLayer)
    }
    
    // MARK: - Vision

    func highlightRecognized(rectOfInterest: CGRect) {
        //draw path and set recognized image
        guard let drawLayer = self.pathLayer else {
            assertionFailure()
            return
        }
        draw(rectOfRecognition: rectOfInterest, onImageWithBounds: drawLayer.bounds)
        drawLayer.setNeedsDisplay()
    }
    
    // MARK: - Path-Drawing
    
    func draw(rectOfRecognition: CGRect, onImageWithBounds bounds: CGRect) {
        CATransaction.begin()

        let rectBox = boundingBox(forRegionOfInterest: rectOfRecognition, withinImageBounds: bounds)
        let rectLayer = shapeLayer(color: .green, frame: rectBox)

        // Add to pathLayer on top of image.
        pathLayer?.addSublayer(rectLayer)

        CATransaction.commit()
    }


    func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {

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

    func shapeLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {
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
}

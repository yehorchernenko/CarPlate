//
//  ImagePicker.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 21.03.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI
import UIKit
public struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType

    public func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(
            presentationMode: presentationMode,
            image: $image
        )
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        controller.sourceType = sourceType
        return controller
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        //Do nothing
    }
}

public extension ImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate {
        @Binding var presentationMode: PresentationMode
        @Binding var image: UIImage?
        public init(presentationMode: Binding<PresentationMode>, image: Binding<UIImage?>) {
            self._presentationMode = presentationMode
            self._image = image
        }
    }
}

extension ImagePicker.Coordinator: UIImagePickerControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        presentationMode.dismiss()
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presentationMode.dismiss()
    }
}

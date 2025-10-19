//
//  CameraPickerView.swift
//  CarPlate
//
//  Created for license plate recognition
//

import SwiftUI

struct CameraPickerView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showCamera = true
    @State private var isShowingRecognition = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .cornerRadius(10)
                }
                
                VStack(spacing: 15) {
                    Button(action: {
                        showCamera = true
                        showImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Take Photo")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showCamera = false
                        showImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo.fill")
                            Text("Choose from Library")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    if selectedImage != nil {
                        NavigationLink(
                            destination: CarPlateRecognitionView(image: $selectedImage),
                            isActive: $isShowingRecognition
                        ) {
                            Button(action: {
                                isShowingRecognition = true
                            }) {
                                HStack {
                                    Image(systemName: "text.viewfinder")
                                    Text("Recognize License Plate")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("License Plate Scanner")
            .sheet(isPresented: $showImagePicker) {
                ImagePickerWrapper(
                    image: $selectedImage,
                    sourceType: showCamera ? .camera : .photoLibrary
                )
            }
        }
    }
}

// UIKit wrapper for UIImagePickerController
struct ImagePickerWrapper: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerWrapper
        
        init(_ parent: ImagePickerWrapper) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CameraPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CameraPickerView()
    }
}


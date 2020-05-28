//
//  SearchListView.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 15.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI
import Combine
struct SearchListView: View {
    @ObservedObject var viewModel: SearchListViewModel
    @State var showActionSheet: Bool = false
    @State var showImagePicker: Bool = false
    @State var showRecognitionView: Bool = false
    @State var showARView: Bool = false
    @State var imageToRecognize: UIImage?
    @State var activePicker: ActivatePicker = .photoLibrary

    enum ActivatePicker {
        case photoLibrary, camera
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Take a photo or choose exiting"), message: nil, buttons: [
            .default(Text("Camera"), action: {
                self.activePicker = .camera
                self.showImagePicker.toggle()
            }),
            .default(Text("Photo Library"), action: {
                self.activePicker = .photoLibrary
                self.showImagePicker.toggle()
            }),
            /*
            .default(Text("AR"), action: {
                self.showARView.toggle()
            }),*/
            .destructive(Text("Cancel"), action: {
                self.showActionSheet.toggle()
            })
        ])
    }

    var imagePicker: AnyView {
        switch $activePicker.wrappedValue {
        case .camera:
            return AnyView(
                ImagePicker(image: self.$imageToRecognize, sourceType: .camera)
                    .onDisappear(perform: self.onImagePickerDisappear)
            )

        case .photoLibrary:
            return AnyView(
                ImagePicker(image: self.$imageToRecognize, sourceType: .photoLibrary)
                    .onDisappear(perform: self.onImagePickerDisappear)
            )
        }
    }

    var navigationLinks: some View {
        Group {
            NavigationLink(destination: CarPlateRecognitionView(image: $imageToRecognize)
                .onDisappear(perform: {
                    self.showRecognitionView = false
                }),
                           isActive: $showRecognitionView,
                           label: { EmptyView() })

            NavigationLink(destination: ARCarPlateRecognitionView()
            .onDisappear(perform: {
                self.showARView = false
            }),
                       isActive: $showARView,
                       label: { EmptyView() })
        }
    }
    
    var searchBar: some View {
        HStack {
            SearchBar(text: $viewModel.searchText, searchAction: self.viewModel.onSearchTouched)
            Button(action: {
                self.showActionSheet.toggle()
            }) {
                Image(systemName: "camera").font(.system(size: 20))
            }.padding(.trailing)
        }
    }
    
    var table: some View {
        VStack {
            ScrollView {
                searchBar
                ForEach(viewModel.list) { item in
                    NavigationLink(destination: CarDetailsView(viewModel: CarDetailsViewModel(carPlateNumber: .constant(item.carPlateNumber)))) {
                        SearchListRow(item: item)
                    }.buttonStyle(PlainButtonStyle())
                }
                .background(Color.searchListViewBg)
                .padding([.leading, .trailing])
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                table
                ActivityIndicator(isAnimating: $viewModel.isLoading)
                navigationLinks
            }
            .navigationBarTitle("Search by carplate", displayMode: .inline)
        }
        .onAppear {
            self.viewModel.load()
        }
        .modifier(OnAppearDismissingKeyboard())
        .actionSheet(isPresented: $showActionSheet, content: { actionSheet })
        .sheet(isPresented: $showImagePicker, content: { self.imagePicker })
        .alert(item: $viewModel.error) { error in
            Alert(title: Text(error.title), message: Text(error.message))
        }
    }
}

private extension SearchListView {
    func onImagePickerDisappear() {
        if self.$imageToRecognize.wrappedValue != nil {
            self.showRecognitionView = true
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchListView(viewModel: SearchListViewModel()).colorScheme(.light)
            SearchListView(viewModel: SearchListViewModel()).colorScheme(.dark)
        }
    }
}

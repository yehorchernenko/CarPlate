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
    @State var showCamera: Bool = false
    @State var showPhotoLibrary: Bool = false { didSet {
        print(showPhotoLibrary)
        }}
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Take a photo or choose exiting"), message: nil, buttons: [
            .default(Text("Camera"), action: {
                self.showActionSheet.toggle()
                self.showCamera.toggle()
            }),
            .default(Text("Photo Library"), action: {
                self.showActionSheet.toggle()
                self.showPhotoLibrary.toggle()
            }),
            .destructive(Text("Cancel"), action: {
                self.showActionSheet.toggle()
            })
        ])
    }
    
    var cameraNavigationLinks: some View {
        Group {
            NavigationLink(destination: Text("Camera")
                .onDisappear(perform: {
                    self.showCamera = false
                }), isActive: $showCamera, label: { EmptyView() })
            NavigationLink(destination: Text("Photo")
                .onDisappear(perform: {
                    self.showPhotoLibrary = false
                }), isActive: $showPhotoLibrary, label: { EmptyView() })
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
                    NavigationLink(destination: CarDetailsView(details: item)) {
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
                cameraNavigationLinks
            }
            .navigationBarTitle("Search by carplate")
        }
        .onAppear {
            self.viewModel.load()
        }
        .modifier(OnAppearDismissingKeyboard())
        .actionSheet(isPresented: $showActionSheet, content: { actionSheet })
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchListView(viewModel: SearchListViewModelMock()).colorScheme(.light)
            SearchListView(viewModel: SearchListViewModelMock()).colorScheme(.dark)
        }
        
    }
}




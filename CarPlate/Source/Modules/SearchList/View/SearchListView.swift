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
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        SearchBar(text: $viewModel.searchText, searchAction: self.viewModel.onSearchTouched)
                        ForEach(viewModel.list) { item in
                            NavigationLink(destination: CarDetailsView(details: item)) {
                                SearchListRow(item: item)
                            }.buttonStyle(PlainButtonStyle())
                            
                        }
                        .padding([.leading, .trailing])
                    }
                    .background(Color.searchListViewBg)
                }
                ActivityIndicator(isAnimating: $viewModel.isLoading)
            }
            .navigationBarTitle("Search by carplate")
        }.onAppear {
            self.viewModel.load()
        }
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




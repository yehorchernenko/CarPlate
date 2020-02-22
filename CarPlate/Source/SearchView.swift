//
//  SearchView.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 15.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    let list: [CarInfo]
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    SearchBar(text: $searchText)
                    ForEach(list) { item in
                        SearchListRow(item: item)
                    }
                    .padding([.leading, .trailing])
                }
                .background(Color.searchListViewBg)
            }
            .navigationBarTitle("Search by carplate")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchView(list: CarInfo.list).colorScheme(.light)
            SearchView(list: CarInfo.list).colorScheme(.dark)
        }
        
    }
}


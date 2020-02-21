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
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(list) { item in
                    SearchListRow(item: item)
                }
                .padding([.leading, .trailing])
            }
        }.navigationBarTitle("Hi")
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

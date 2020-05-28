//
//  HistoryList.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 28.05.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI

struct HistoryList: View {
    var records: [CarInfoDisplayModel]

    var body: some View {
        ScrollView {
            ForEach(records) { item in
                NavigationLink(destination: CarDetailsView(viewModel: CarHistoryDetailsViewModel(details: item))) {
                    SearchListRow(item: item)
                }.buttonStyle(PlainButtonStyle())
            }
            .background(Color.searchListViewBg)
            .padding([.top, .leading, .trailing])
        }
    }
}

struct HistoryList_Preview: PreviewProvider {
    static var previews: some View {
        HistoryList(records: [.empty, .fake])
    }
}

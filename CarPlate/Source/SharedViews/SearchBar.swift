//
//  SearchBar.swift
//  CarPlate
//
//  Created by Yehor Chernenko on 22.02.2020.
//  Copyright © 2020 Yehor Chernenko. All rights reserved.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    typealias UIViewType = UISearchBar
    
    @Binding var text: String
    var searchAction: () -> Void
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        text = searchText
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UIViewType {
        
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.backgroundImage = UIImage()
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, searchAction: searchAction)
    }
    
    class Coordinator : NSObject, UISearchBarDelegate {
        @Binding var text : String
        var searchAction: () -> Void
        
        init(text : Binding<String>, searchAction: @escaping () -> Void) {
            _text = text
            self.searchAction = searchAction
        }
        
        func searchBar(_ searchBar: UISearchBar,
                       textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchAction()
            searchBar.endEditing(true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
        }
    }
}


struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), searchAction: { }).previewLayout(.fixed(width: 350, height: 50))
    }
}

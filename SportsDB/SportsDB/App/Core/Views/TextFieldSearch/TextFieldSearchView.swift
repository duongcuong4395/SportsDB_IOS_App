//
//  TextFieldSearchView.swift
//  SportsDB
//
//  Created by Macbook on 1/9/25.
//

import SwiftUI

struct TextFieldSearchView: View {
    @State var listModels: [[Any]]
    @Binding var textSearch: String

    @State var showClear: Bool = false
    var body: some View {
        
        
        HStack{
            Image(systemName: "magnifyingglass")
                .padding(.leading, 5)
            TextField("Enter text", text: $textSearch)
                
            if showClear {
                if !textSearch.isEmpty {
                    Button(action: {
                        self.textSearch = ""
                        for i in 0..<listModels.count {
                            listModels[i] = []
                        }
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                    //.foregroundStyleItemView(by: appVM.appMode)
                    .padding(.trailing, 5)
                }
            }
        }
        //.avoidKeyboard()
        .padding(5)
        .padding(.vertical, 3)
        .themedBackground(.card(tintColor: .blue))
        
    }
}

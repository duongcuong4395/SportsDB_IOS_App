//
//  ProductListView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

struct ProductListView: View {
    let category: String
    @EnvironmentObject var router: ShopRouter
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Products in \(category.capitalized)")
                .font(.title2)
            
            ForEach(1...5, id: \.self) { index in
                Button("Product \(index)") {
                    router.navigateToProduct(id: "\(category)-\(index)", from: category)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .navigationTitle(category.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//
//  ProductDetailView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

struct ProductDetailView: View {
    let productId: String
    @EnvironmentObject var router: ShopRouter
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Product Details")
                .font(.title)
            
            Text("Product ID: \(productId)")
                .font(.body)
                .foregroundColor(.secondary)
            
            Button("Add to Cart & View Cart") {
                router.navigateToCart()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .navigationTitle("Product")
        .navigationBarTitleDisplayMode(.inline)
    }
}

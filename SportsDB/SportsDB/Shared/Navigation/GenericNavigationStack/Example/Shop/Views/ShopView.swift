//
//  ShopView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

// MARK: - Views
struct ShopView: View {
    @EnvironmentObject var router: ShopRouter
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Shop Categories")
                .font(.largeTitle)
                .bold()
            
            Button("Electronics") {
                router.push(.productList(category: "electronics"))
            }
            
            Button("Clothing") {
                router.push(.productList(category: "clothing"))
            }
            
            Button("View Cart") {
                router.navigateToCart()
            }
        }
        .navigationTitle("Shop")
    }
}

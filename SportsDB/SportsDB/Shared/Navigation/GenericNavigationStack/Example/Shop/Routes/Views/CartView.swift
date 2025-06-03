//
//  CartView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var router: ShopRouter
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Shopping Cart")
                .font(.title)
            
            Text("Your cart items here...")
                .foregroundColor(.secondary)
            
            Button("Proceed to Checkout") {
                router.push(.checkout)
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .navigationTitle("Cart")
    }
}

//
//  CheckoutView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

struct CheckoutView: View {
    var body: some View {
        VStack {
            Text("Checkout")
                .font(.title)
            
            Text("Complete your purchase...")
                .foregroundColor(.secondary)
        }
        .navigationTitle("Checkout")
    }
}

//
//  OrderDetailView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

struct OrderDetailView: View {
    let orderId: String
    
    var body: some View {
        Text("Order Details: \(orderId)")
            .navigationTitle("Order Detail")
    }
}

//
//  OrderHistoryView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

struct OrderHistoryView: View {
    @EnvironmentObject var router: ProfileRouter
    
    var body: some View {
        VStack {
            Text("Order History")
            
            ForEach(1...3, id: \.self) { index in
                Button("Order #\(index)") {
                    router.navigateToOrderDetail(id: "order-\(index)")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .navigationTitle("Orders")
    }
}

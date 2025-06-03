//
//  GenericNavigationStackView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

struct GenericNavigationStackView: View {
    @StateObject private var shopRouter = ShopRouter()
    @StateObject private var profileRouter = ProfileRouter()
    
    var body: some View {
        TabView {
            GenericNavigationStack(router: shopRouter) {
                ShopView()
            } destination: { route in
                shopDestination(route)
            }
            .tabItem {
                Image(systemName: "bag")
                Text("Shop")
            }
            
            GenericNavigationStack(router: profileRouter) {
                ProfileView()
            } destination: { route in
                profileDestination(route)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }
    }
    
    @ViewBuilder
    private func shopDestination(_ route: ShopRoute) -> some View {
        switch route {
        case .productList(let category):
            ProductListView(category: category)
        case .productDetail(let id):
            ProductDetailView(productId: id)
        case .cart:
            CartView()
        case .checkout:
            CheckoutView()
        }
    }
    
    @ViewBuilder
    private func profileDestination(_ route: ProfileRoute) -> some View {
        switch route {
        case .settings:
            SettingsView()
        case .editProfile:
            EditProfileView()
        case .orderHistory:
            OrderHistoryView()
        case .orderDetail(let id):
            OrderDetailView(orderId: id)
        }
    }
}




//
//  ShopRouter.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

// MARK: - Example Routes cho các danh mục khác nhau
enum ShopRoute: Hashable {
    case productList(category: String)
    case productDetail(id: String)
    case cart
    case checkout
}

// MARK: - Specific Routers
class ShopRouter: BaseRouter<ShopRoute> {
    func navigateToProduct(id: String, from category: String) {
        push(.productDetail(id: id))
    }
    
    func navigateToCart() {
        push(.cart)
    }
}

//
//  ProfileRouter.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

enum ProfileRoute: Hashable {
    case settings
    case editProfile
    case orderHistory
    case orderDetail(id: String)
}

class ProfileRouter: BaseRouter<ProfileRoute> {
    func navigateToSettings() {
        push(.settings)
    }
    
    func navigateToOrderDetail(id: String) {
        push(.orderDetail(id: id))
    }
}

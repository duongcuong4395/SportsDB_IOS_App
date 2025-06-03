//
//  ProfileView.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

// MARK: - Profile Views (Simple implementations)
struct ProfileView: View {
    @EnvironmentObject var router: ProfileRouter
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile")
                .font(.largeTitle)
                .bold()
            
            Button("Settings") {
                router.navigateToSettings()
            }
            
            Button("Edit Profile") {
                router.push(.editProfile)
            }
            
            Button("Order History") {
                router.push(.orderHistory)
            }
        }
        .navigationTitle("Profile")
    }
}

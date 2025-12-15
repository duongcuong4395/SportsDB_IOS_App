//
//  NavigationToNotificationView.swift
//  SportsDB
//
//  Created by Macbook on 1/9/25.
//

import SwiftUI

struct NavigationToNotificationView: View {
    @EnvironmentObject var notificationListVM: NotificationListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: notificationListVM.notifications.count > 0 ? "bell.fill" : "bell")
                .font(.title3)
                .frame(width: 25, height: 25)
            Text("Notification")
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(5)
        .themedBackground(.button(cornerRadius: 50, material: .ultraThinMaterial))
        .onTapGesture {
            if !sportRouter.isAtNotification {
                sportRouter.navigateToNotification()
            }
        }
        .padding(.top, 5)
        .overlay(alignment: .topTrailing) {
            Color.clear
                .customBadge(notificationListVM.notifications.count)
        }
    }
}

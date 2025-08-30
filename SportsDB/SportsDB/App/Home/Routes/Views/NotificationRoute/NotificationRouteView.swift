//
//  NotificationRouteView.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import SwiftUI

struct NotificationRouteView: View {
    @EnvironmentObject var manageNotificationRouteVM: ManageNotificationRouteViewModel
    
    var body: some View {
        RouteGenericView(
            headerView: NotificationRouteHeaderView()
            , contentView: NotificationRouteContentView())
        .onAppear{
            manageNotificationRouteVM.loadNotifySaved()
        }
        .alert("Remove from notification saved", isPresented: $manageNotificationRouteVM.showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let notify = manageNotificationRouteVM.notifyToDelete {
                    print("=== remove noti")
                    manageNotificationRouteVM.handleToggleNotification(notify)
                } else {
                    print("=== no noti remove")
                }
            }
        } message: {
            Text("Are you sure you want to remove this item from your notification saved?")
        }
        
    }
}


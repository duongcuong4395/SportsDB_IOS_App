//
//  NotificationRouteHeaderView.swift
//  SportsDB
//
//  Created by Macbook on 30/8/25.
//

import SwiftUI

struct NotificationRouteHeaderView: View {
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var manageNotificationRouteVM: ManageNotificationRouteViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                sportRouter.pop()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
            })
            
            HStack(spacing: 8) {
                Image(systemName: manageNotificationRouteVM.notifications.count > 0 ? "bell.fill" : "bell")
                    .font(.body)
                    
                Text("Notification")
                    .font(.body.bold())
                
                if !manageNotificationRouteVM.notifications.isEmpty {
                    Text("(\(manageNotificationRouteVM.notifications.count))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .contentTransition(.numericText())
                        
                }
            }
            .onTapGesture {
                sportRouter.pop()
            }
            Spacer()
            
            if !manageNotificationRouteVM.notifications.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        manageNotificationRouteVM.toggleSelectionMode()
                        manageNotificationRouteVM.resetNotifySelected()
                        //isSelectionMode.toggle()
                        //selectedNotify.removeAll()
                    }
                }) {
                    Image(systemName: manageNotificationRouteVM.isSelectionMode ?  "checkmark.circle.fill" : "checklist")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.horizontal, 16)
        //.backgroundOfRouteHeaderView(with: 70)
        .backgroundByTheme(for: .Header(height: 70))
    }
}

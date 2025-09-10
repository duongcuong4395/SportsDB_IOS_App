//
//  SportDBView.swift
//  SportsDB
//
//  Created by Macbook on 5/6/25.
//

import SwiftUI
import SwiftData


struct SportDBView: View {
    @StateObject private var container = AppDependencyContainer()
    @Environment(\.isNetworkConnected) private var isConnected
    @Environment(\.connectionType) private var connectionType
    
    var body: some View {
        VStack(spacing: 0) {
            GenericNavigationStack(
                router: container.sportRouter
             , rootContent: {
                 ListCountryRouteView()
                     .backgroundOfPage(by: .Gradient)
             }
             , destination: sportDestination
            )
        }
        .padding(0)
        
        .overlay(alignment: .bottomLeading, content: {
            bottomOverlay
        })
        .overlay(content: {
            DialogView()
                .environmentObject(container.aiManageVM)
        })
        .injectDependencies(container)
        .onAppear(perform: container.appAppear)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NavigateToEvent"))) { notification in
            
            container.handleNavigateToEvent(from: notification)
        }
        .onChange(of: container.notificationListVM.tappedNotification) { oldVL, notification in
            if let notification = notification {
                handleTappedNotification(notification)
            }
        }
        .sheet(isPresented: .constant(!(isConnected ?? true))) {
            NoInternetView()
                .presentationDetents([.height(310)])
                .presentationCornerRadius(0)
                .presentationBackgroundInteraction(.disabled)
                .presentationBackground(.clear)
                .interactiveDismissDisabled()
        }
    }
       
   private func handleTappedNotification(_ notification: NotificationItem) {
       print("📱 Notification tapped in UI: \(notification.title)")
       if let eventId = notification.userInfo["idEvent"] {
           print("Should navigate to event: \(eventId)")
       }
   }
    
}

// MARK: bottomOverlay
extension SportDBView {
    @ViewBuilder
    var bottomOverlay: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    SelectSportView(tappedSport: { sport in
                        container.tapSport()
                    })
                    .padding(.horizontal, 5)
                    .padding(.top, 5)
                    
                    NavigationToNotificationView()
                    NavigationToLikedView()
                    
                    //ButtonTestNotificationView()
                }
            }
        }
    }
}

// MARK: Sport Destination View
private extension SportDBView {
    @ViewBuilder
    func sportDestination(_ route: SportRoute) -> some View {
        route.destinationView()
    }
}





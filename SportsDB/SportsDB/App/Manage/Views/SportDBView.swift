//
//  SportDBView.swift
//  SportsDB
//
//  Created by Macbook on 5/6/25.
//

import SwiftUI
import SwiftData
import Networking
import NavigationRouter


struct SportDBView: View {
    @StateObject private var container = AppDependencyContainer()
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationRouter(
                router: container.sportRouter
             , rootContent: {
                 ListCountryRouteView()
                     .backgroundOfPage(by: .Gradient)
             }
             , destination: sportDestination
            )
            
            if networkMonitor.isVPNActive {
                Label("VPN is active", systemImage: "lock.shield.fill")
                        .foregroundStyle(.orange)
                        .font(.caption)
            }
        }
        .padding(0)
        .overlay(alignment: .bottomLeading, content: {
            bottomOverlay
        })
        .overlay(content: {
            DialogView()
                .environmentObject(container.aiManageVM)
        })
        .overlay(content: {
            if !networkMonitor.isConnected{
                NoInternetView()
                    .presentationDetents([.height(310)])
                    .presentationCornerRadius(0)
                    .presentationBackgroundInteraction(.disabled)
                    .presentationBackground(.clear)
                    .interactiveDismissDisabled()
            }
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
    }
}


extension SportDBView {
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

struct ButtonTestNotificationView: View {
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                Image(systemName: "bell")
                    .font(.title3)
                    .frame(width: 25, height: 25)
                    
                Text("Test Notify")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            //.backgroundOfItemTouched()
            .backgroundByTheme(for: .Button(material: .ultraThin, cornerRadius: .roundedCorners))
            .onTapGesture {
                addScheduleNotification()
            }
        }
        .padding(.top, 5)
    }
    
    func addScheduleNotification() {
        let eventExample = getEventExample()
        guard let notiItem = eventExample.notificationItemTest else { return }
        
        NotificationManager.shared.scheduleNotification(notiItem)
    }
}

//
//  SportsDBApp.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import SwiftUI

@main
struct SportsDBApp: App {
    
    var body: some Scene {
        WindowGroup {
            SportDBView_New()
                .environmentObject(NetworkManager.shared)
        }
        .modelContainer(MainDB.shared)
        .environmentObject(NetworkManager.shared)
    }
}

struct SportDBView_New: View {
    @StateObject private var container = AppDependencyContainer()
    //@EnvironmentObject var notificationListVM: NotificationListViewModel
    
    var body: some View {
        GenericNavigationStack(
            router: container.sportRouter
         , rootContent: {
             ListCountryRouteView()
                 .backgroundGradient()
         }
         , destination: sportDestination
        )
        .overlay(alignment: .bottomLeading, content: {
            bottomOverlay
        })
        .overlay(content: {
            DialogView()
                .environmentObject(container.aiManageVM)
        })
        .injectDependencies(container)
        .onAppear(perform: onAppear)
        // Bắt sự kiện khi nhấn vào thông báo
        // khi app đã tắt hoặc cả khi app đang ở background hoặc app đang active
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NavigateToEvent"))) { notification in
            handleNavigateToEvent(notification)
        }
        .onChange(of: container.notificationListVM.tappedNotification) { oldVL, notification in
            if let notification = notification {
                handleTappedNotification(notification)
            }
        }
    }
    
    private func handleNavigateToEvent(_ notification: Notification) {
       guard let eventId = notification.userInfo?["eventId"] as? String,
             let notificationItem = notification.userInfo?["notification"] as? NotificationItem else {
           return
       }
       
       print("🚀 Navigating to event: \(eventId)")
        let event = notificationItem.toEvent()
        container.eventDetailVM.setEventDetail(event)
        container.sportRouter.navigateToEventDetail()
        
    
       // Thực hiện navigation tại đây
       // Ví dụ: push to event detail screen
       // container.sportRouter.push(EventDetailRoute(eventId: eventId))
   }
       
   private func handleTappedNotification(_ notification: NotificationItem) {
       // Xử lý khi có notification được tap
       print("📱 Notification tapped in UI: \(notification.title)")
       dump(notification)
       
       // Có thể show alert, navigation, etc.
       if let eventId = notification.userInfo["idEvent"] {
           // Navigate to specific event
           print("Should navigate to event: \(eventId)")
       }
   }
    
}

extension SportDBView_New {
    private func onAppear() {
        Task {
            await container.notificationListVM.loadNotifications()
            await container.eventSwiftDataVM.loadEvents()
            _ = await container.aiManageVM.getKey()
        }
    }
}

// MARK: bottomOverlay
extension SportDBView_New {
    @ViewBuilder
    var bottomOverlay: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                SelectSportView(tappedSport: { sport in
                    onTapSport()
                })
                .padding(.horizontal, 5)
                .padding(.top, 5)
                
                NavigationToNotificationView()
                
                NavigationToLikedView()
                
                ButtonTestNotificationView()
            }
        }
        
    }
    
    func onTapSport() {
        container.sportRouter.popToRoot()
        
        container.leagueListVM.resetAll()
        container.leagueDetailVM.resetAll()
        
        container.teamListVM.resetAll()
        container.teamDetailVM.resetAll()
        
        container.seasonListVM.resetAll()
        
        container.eventListVM.resetAll()
        container.eventsInSpecificInSeasonVM.resetAll()
        container.eventsRecentOfLeagueVM.resetAll()
        container.eventsPerRoundInSeasonVM.resetAll()
        container.eventsOfTeamByScheduleVM.resetAll()
        
        container.playerListVM.resetAll()
        container.trophyListVM.resetAll()
    }
}

// MARK: Sport Destination View
private extension SportDBView_New {
    @ViewBuilder
    func sportDestination(_ route: SportRoute) -> some View {
        VStack {
            switch route {
            case .ListCountry:
                ListCountryRouteView()
            case .ListLeague(by: let country, and: let sport):
                ListLeagueRouteView(country: country, sport: sport)
                    .navigationBarHidden(true)
            case .LeagueDetail(by: _):
                LeagueDetailRouteView()
                    .navigationBarHidden(true)
            case .TeamDetail:
                TeamDetailRouteView()
                .padding(0)
                .navigationBarHidden(true)
            case .Notification:
                NotificationRouteView()
                    .navigationBarHidden(true)
            case .Like:
                LikeRouteView()
                    .navigationBarHidden(true)
            case .EventDetail:
                EventDetailRouteView()
                    .navigationBarHidden(true)
            }
        }
        .backgroundGradient()
    }
}

// MARK: - Dependency Injection Extension
extension View {
    func injectDependencies(_ container: AppDependencyContainer) -> some View {
        self
            .environmentObject(container.appVM)
            .environmentObject(container.sportVM)
            .environmentObject(container.countryListVM)
            .environmentObject(container.leagueListVM)
            .environmentObject(container.leagueDetailVM)
            .environmentObject(container.seasonListVM)
            .environmentObject(container.teamListVM)
            .environmentObject(container.teamDetailVM)
            .environmentObject(container.playerListVM)
            .environmentObject(container.trophyListVM)
        
            .environmentObject(container.eventListVM)
            .environmentObject(container.eventsInSpecificInSeasonVM)
            .environmentObject(container.eventsRecentOfLeagueVM)
            .environmentObject(container.eventsPerRoundInSeasonVM)
            .environmentObject(container.eventsOfTeamByScheduleVM)
            .environmentObject(container.eventDetailVM)
        
            .environmentObject(container.sportRouter)
            .environmentObject(container.eventSwiftDataVM)
            .environmentObject(container.aiManageVM)
            .environmentObject(container.teamSelectionManager)
            .environmentObject(container.notificationListVM)
        
            .environmentObject(container.eventToggleLikeManager)
            .environmentObject(container.eventToggleNotificationManager)
        
        
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
            .padding(5)
            .background{
                Color.clear
                    .liquidGlass(intensity: 0.3, tintColor: .orange, hasShimmer: true, hasGlow: true)
            }
            .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            .onTapGesture {
                let eventExample = getEventExample()
                guard let notiItem = eventExample.notificationItemTest else { return }
                
                NotificationManager.shared.scheduleNotification(notiItem)
            }
        }
        .padding(.top, 5)
    }
}





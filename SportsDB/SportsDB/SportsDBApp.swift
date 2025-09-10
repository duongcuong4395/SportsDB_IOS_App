//
//  SportsDBApp.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import SwiftUI

@main
struct SportsDBApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            SportDBView()
                .environment(\.isNetworkConnected, networkMonitor.isConnected)
                .environment(\.connectionType, networkMonitor.connectionType)
        }
        .modelContainer(MainDB.shared)
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
            
            .environmentObject(container.notificationListVM)
        
            .environmentObject(container.teamSelectionManager)
            .environmentObject(container.eventToggleLikeManager)
            .environmentObject(container.eventToggleNotificationManager)
        
            .environmentObject(container.manageLikeRouteVM)
            .environmentObject(container.manageNotificationRouteVM)
            .environmentObject(container.manageEventsGenericVM)
        
        
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
            .backgroundOfItemTouched()
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









                            

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
    
    @StateObject var adaptiveLayoutManager = AdaptiveLayoutManager()
    
    var body: some Scene {
        /*
        WindowGroup {
            SmartResponsiveDemo()
                .environmentObject(adaptiveLayoutManager)
        }
        */
        
        
        WindowGroup {
            SportDBView()
                .environment(\.isNetworkConnected, networkMonitor.isConnected)
                .environment(\.connectionType, networkMonitor.connectionType)
                .environmentObject(adaptiveLayoutManager)
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











                            

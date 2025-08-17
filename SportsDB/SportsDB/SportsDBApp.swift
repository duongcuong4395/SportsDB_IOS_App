//
//  SportsDBApp.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import SwiftUI

@main
struct SportsDBApp: App {
    @StateObject var notificationListVM = NotificationListViewModel()
    //private let container = SwiftDataContainer.shared
    
    init() {
        // Notification
        let center = UNUserNotificationCenter.current()
        center.delegate = NotificationDelegate.shared
    }
    
    var body: some Scene {
        WindowGroup {
            //SportDBView()
            SportDBView_New()
                .environmentObject(NetworkManager.shared)
                .onAppear{
                    Task {
                        await notificationListVM.loadNotifications()
                    }
                }
        }
        .modelContainer(MainDB.shared)
        .environmentObject(NetworkManager.shared)
        .environmentObject(notificationListVM)
        
        
        //.modelContainer(container.container)
    }
}



struct SportDBView_New: View {
    @StateObject private var container = AppDependencyContainer()
    
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
        .onReceive(NotificationCenter.default.publisher(for: .navigateToEventDetail)) { output in
            handleEventDetailNavigation(output)
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
    
    @ViewBuilder
    var bottomOverlay: some View {
        HStack(spacing: 10) {
            SelectSportView(tappedSport: { sport in
                onTapSport()
            })
            .padding(.horizontal, 5)
            .padding(.top, 5)
            
            NavigationToNotificationView()
            
            NavigationToLikedView()
        }
    }
    
    @ViewBuilder
    var networkStatusOverlay: some View {
        if !NetworkManager.shared.isConnected {
            NetworkNotConnectView()
                .ignoresSafeArea()
                .background{
                    Color.clear
                        .liquidGlass(intensity: 0.8)
                        .ignoresSafeArea()
                        
                }
        }
    }
    
    private func handleEventDetailNavigation(_ output: NotificationCenter.Publisher.Output) {
        container.sportRouter.navigateToNotification()
        if let idEvent = output.userInfo?["idEvent"] as? String {
            print("🚀 Navigate to event with idEvent:", idEvent)
        }
    }
    
    private func onAppear() {
        //chatVM.initChat()
        
        Task {
            await container.eventSwiftDataVM.loadEvents()
            _ = await container.aiManageVM.getKey()
        }
    }
}


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
            .environmentObject(container.sportRouter)
            .environmentObject(container.eventSwiftDataVM)
            .environmentObject(container.aiManageVM)
            .environmentObject(container.teamSelectionManager)
    }
}

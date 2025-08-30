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
            SportDBView_New()
                .environment(\.isNetworkConnected, networkMonitor.isConnected)
                .environment(\.connectionType, networkMonitor.connectionType)
        }
        .modelContainer(MainDB.shared)
    }
}

struct SportDBView_New: View {
    @StateObject private var container = AppDependencyContainer()
    @Environment(\.isNetworkConnected) private var isConnected
    @Environment(\.connectionType) private var connectionType
    
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
       // Xử lý khi có notification được tap
       print("📱 Notification tapped in UI: \(notification.title)")
       
       // Có thể show alert, navigation, etc.
       if let eventId = notification.userInfo["idEvent"] {
           // Navigate to specific event
           print("Should navigate to event: \(eventId)")
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

// MARK: Sport Destination View
private extension SportDBView_New {
    @ViewBuilder
    func sportDestination(_ route: SportRoute) -> some View {
        route.destinationView()
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




struct BackgroundOfItemTouchedModifier: ViewModifier {
    var tintColor: Color
    var cornerRadius: Double
    var intensity: Double
    var hasGlow: Bool
    var hasShimmer: Bool
    func body(content: Content) -> some View {
        content
            .padding(5)
            .background{
                Color.clear
                    .liquidGlass(intensity: intensity, tintColor: tintColor, hasShimmer: hasShimmer, hasGlow: hasGlow)
            }
            .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

extension View {
    func backgroundOfItemTouched(color: Color = .orange, cornerRadius: Double = 20, intensity: Double = 0.8, hasGlow: Bool = true, hasShimmer: Bool = true) -> some View {
        self.modifier(BackgroundOfItemTouchedModifier(tintColor: color, cornerRadius: cornerRadius, intensity: intensity, hasGlow: hasGlow, hasShimmer: hasShimmer))
    }
}


extension View {
    func backgroundGradient() -> some View {
        self.background{
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.3),
                    Color.pink.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}

import Kingfisher
extension View {
    func backgroundOfRouteView(with image: String) -> some View {
        self.background {
            KFImage(URL(string: image))
                .placeholder { progress in
                    ProgressView()
                }
                .opacity(0.1)
                .ignoresSafeArea(.all)
        }
    }
}


extension View {
    func backgroundOfRouteHeaderView(with height: CGFloat = 70) -> some View {
        self.padding(.horizontal)
            .frame(height: height)
            .background {
                Color.clear
                    .liquidGlass(intensity: 0.8)
                    .ignoresSafeArea(.all)
            }
    }
}


extension View {
    func liquidGlassForTabView<T>(with tag: T) -> some View where T : Hashable {
        self.liquidGlassForCardView()
            .tag(tag)
    }
}

extension View {
    func liquidGlassForCardView(intensity: Double = 0.8,
                                cornerRadius: CGFloat = 20) -> some View {
        self.liquidGlass(intensity: intensity, cornerRadius: cornerRadius)
            .padding(.horizontal, 5)
    }
}

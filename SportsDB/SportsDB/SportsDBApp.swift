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
            .environmentObject(container.teamSelectionManager)
            .environmentObject(container.notificationListVM)
        
            .environmentObject(container.eventToggleLikeManager)
            .environmentObject(container.eventToggleNotificationManager)
            .environmentObject(container.manageLikeRouteVM)
            .environmentObject(container.manageNotificationRouteVM)
        
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
    var padding: CGFloat
    var tintColor: Color
    var cornerRadius: Double
    var intensity: Double
    var hasGlow: Bool
    var hasShimmer: Bool
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background{
                Color.clear
                    .liquidGlass(intensity: intensity, tintColor: tintColor, hasShimmer: hasShimmer, hasGlow: hasGlow)
            }
            .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

extension View {
    func backgroundOfItemTouched(padding: CGFloat = 5, color: Color = .orange, cornerRadius: Double = 20, intensity: Double = 0.8, hasGlow: Bool = true, hasShimmer: Bool = true) -> some View {
        self.modifier(BackgroundOfItemTouchedModifier(padding: padding, tintColor: color, cornerRadius: cornerRadius, intensity: intensity, hasGlow: hasGlow, hasShimmer: hasShimmer))
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

struct BackgroundItemSelectedViewModifier: ViewModifier {
    var padding: CGFloat = 10
    var hasShimmer: Bool = true
    var isSelected: Bool
    var animation: Namespace.ID
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func body(content: Content) -> some View {
        content
            .font(.callout.bold())
        
            .foregroundColor(isSelected ? .black : (colorScheme == .light ? .gray : .white))
        
            .padding(padding)
            .background{
                if isSelected {
                    Color.clear
                        .backgroundOfItemTouched(color: .blue, intensity: 0.8, hasShimmer: hasShimmer)
                        .matchedGeometryEffect(id: "season", in: animation)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
    
}
    

extension View {
    func backgroundItemSelected(padding: CGFloat = 10, hasShimmer: Bool = true, isSelected: Bool, animation: Namespace.ID) -> some View {
        self.modifier(BackgroundItemSelectedViewModifier(padding: padding, hasShimmer: hasShimmer, isSelected: isSelected, animation: animation))
    }
}
                            

//
//  SportDBView.swift
//  SportsDB
//
//  Created by Macbook on 5/6/25.
//

import SwiftUI
import SwiftData


// MARK: - Simplified ContentView
struct SportDBView: View {
    @StateObject var appVM = AppViewModel()
    
    // MARK: - Router
    @StateObject private var sportRouter = SportRouter()

    // MARK: - ViewModels
    @StateObject private var sportVM = SportViewModel()
    @StateObject private var countryListVM = CountryListViewModel(
        useCase: GetAllCountriesUseCase(repository: CountryAPIService())
    )
    @StateObject private var leagueListVM = LeagueListViewModel(
        getLeaguesUseCase: GetLeaguesUseCase(repository: LeagueAPIService()),
        lookupLeagueUseCase: LookupLeagueUseCase(repository: LeagueAPIService()),
        lookupLeagueTableUseCase: LookupLeagueTableUseCase(repository: LeagueAPIService())
    )
    @StateObject private var leagueDetailVM = LeagueDetailViewModel()
    @StateObject private var seasonListVM = SeasonListViewModel(
        getListSeasonsUseCase: GetListSeasonsUseCase(repository: SeasonAPIService())
    )
    @StateObject private var teamListVM = TeamListViewModel(
        getListTeamsUseCase: GetListTeamsUseCase(repository: TeamAPIService()),
        searchTeamsUseCase: SearchTeamsUseCase(repository: TeamAPIService())
    )
    @StateObject private var teamDetailVM = TeamDetailViewModel(
        lookupEquipmentUseCase: LookupEquipmentUseCase(repository: TeamAPIService())
    )
    @StateObject private var eventListVM = EventListViewModel(
        searchEventsUseCase: SearchEventsUseCase(repository: EventAPIService()),
        lookupEventUseCase: LookupEventUseCase(repository: EventAPIService())
        //lookupListEventsUseCase: LookupListEventsUseCase(repository: EventAPIService()),
        //lookupEventsInSpecificUseCase: LookupEventsInSpecificUseCase(repository: EventAPIService()),
        //lookupEventsPastLeagueUseCase: LookupEventsPastLeagueUseCase(repository: EventAPIService()),
        //getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase(repository: EventAPIService())
    )
    
    
    
    
    // MARK: Event Swift Data
    @StateObject var eventSwiftDataVM: EventSwiftDataViewModel
    @StateObject var aiManageVM: AIManageViewModel
    
    // MARK: List Events
    @StateObject private var eventsInSpecificInSeasonVM = EventsInSpecificInSeasonViewModel(
        lookupEventsInSpecificUseCase: LookupEventsInSpecificUseCase(repository: EventAPIService()))
    
    @StateObject private var eventsRecentOfLeagueVM = EventsRecentOfLeagueViewModel(lookupEventsPastLeagueUseCase: LookupEventsPastLeagueUseCase(repository: EventAPIService()))
    
    @StateObject private var eventsPerRoundInSeasonVM = EventsPerRoundInSeasonViewModel(lookupListEventsUseCase: LookupListEventsUseCase(repository: EventAPIService()))
    
    @StateObject private var eventsOfTeamByScheduleVM = EventsOfTeamByScheduleViewModel(getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase(repository: EventAPIService()))
    
    @StateObject private var playerListVM = PlayerListViewModel(
        lookupPlayerUseCase: LookupPlayerUseCase(repository: PlayerAPIService()),
        searchPlayersUseCase: SearchPlayersUseCase(repository: PlayerAPIService()),
        lookupHonoursUseCase: LookupHonoursUseCase(repository: PlayerAPIService()),
        lookupFormerTeamsUseCase: LookupFormerTeamsUseCase(repository: PlayerAPIService()),
        lookupMilestonesUseCase: LookupMilestonesUseCase(repository: PlayerAPIService()),
        lookupContractsUseCase: LookupContractsUseCase(repository: PlayerAPIService()),
        lookupAllPlayersUseCase: LookupAllPlayersUseCase(repository: PlayerAPIService())
    )
    @StateObject private var trophyListVM = TrophyListViewModel()
    
    @Namespace var animation
    
    init() {
        let repo = EventSwiftDataRepository(context: ModelContext(MainDB.shared))
        let useCase = EventSwiftDataUseCase(repository: repo)
        self._eventSwiftDataVM = StateObject(wrappedValue: EventSwiftDataViewModel(
            context: ModelContext(MainDB.shared)
            , useCase: useCase))
        
        let repoAI = AISwiftDataRepository(context: ModelContext(MainDB.shared))
        let useCaseAI = AIManageUseCase(repository: repoAI)
        self._aiManageVM = StateObject(wrappedValue: AIManageViewModel(
            context: ModelContext(MainDB.shared)
            , useCase: useCaseAI))
        
    }
    
    var body: some View {
        GenericNavigationStack(
         router: sportRouter
         , rootContent: {
             ListCountryRouteView()
                 .backgroundGradient()
         }
         , destination:
             sportDestination
        )
        .overlay(alignment: .bottomLeading, content: {
            HStack(spacing: 10) {
                SelectSportView(tappedSport: { sport in
                    onTapSport()
                })
                .padding(.horizontal, 5)
                .padding(.top, 5)
                
                NavigationToNotificationView()
                
                NavigationToLikedView()
            }
        })
        .overlay(content: {
            if !NetworkManager.shared.isConnected {
                NetworkNotConnectView()
                    .ignoresSafeArea()
                    .background{
                        Color.clear
                            .liquidGlass(intensity: 0.8)
                            .ignoresSafeArea()
                            
                    }
            }
            
            
        })
        .overlay(content: {
            DialogView()
                .environmentObject(aiManageVM)
        })
        .environmentObject(appVM)
        .environmentObject(sportVM)
        
        .environmentObject(countryListVM)
        
        .environmentObject(leagueListVM)
        .environmentObject(leagueDetailVM)
        
        .environmentObject(seasonListVM)
        
        .environmentObject(teamListVM)
        .environmentObject(teamDetailVM)
        
        .environmentObject(playerListVM)
        .environmentObject(trophyListVM)
        
        .environmentObject(eventListVM)
        .environmentObject(eventsInSpecificInSeasonVM)
        .environmentObject(eventsRecentOfLeagueVM)
        .environmentObject(eventsPerRoundInSeasonVM)
        .environmentObject(eventsOfTeamByScheduleVM)
        
        .environmentObject(sportRouter)
        
        .environmentObject(eventSwiftDataVM)
        .environmentObject(aiManageVM)
        
        .onAppear(perform: onAppear)
        
        .onReceive(NotificationCenter.default.publisher(for: .navigateToEventDetail)) { output in
            sportRouter.navigateToNotification()
            if let idEvent = output.userInfo?["idEvent"] as? String {
                print("🚀 Navigate to event with idEvent:", idEvent)
            }
        }
    }
}


// MARK: - Navigation Destinations
private extension SportDBView {
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
                EmptyView()
            }
        }
        .backgroundGradient()
    }
}

private extension SportDBView {
    private func onAppear() {
        //chatVM.initChat()
        
        Task {
            await eventSwiftDataVM.loadEvents()
            _ = await aiManageVM.getKey()
        }
    }
    
    func onTapSport() {
        sportRouter.popToRoot()
        
        leagueListVM.resetAll()
        leagueDetailVM.resetAll()
        
        teamListVM.resetAll()
        teamDetailVM.resetAll()
        
        seasonListVM.resetAll()
        
        eventListVM.resetAll()
        eventsInSpecificInSeasonVM.resetAll()
        eventsRecentOfLeagueVM.resetAll()
        eventsPerRoundInSeasonVM.resetAll()
        eventsOfTeamByScheduleVM.resetAll()
        
        playerListVM.resetAll()
        trophyListVM.resetAll()
    }
}

extension View {
    func backgroundGradient() -> some View {
        self.background{
            // Background gradient
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


struct DialogView: View {
    @EnvironmentObject var appVM: AppViewModel
    var body: some View {
        if appVM.showDialog {
            CustomDialogView(title: appVM.titleDialog, buttonTitle: appVM.titleButonAction, action: {
                withAnimation(.spring()) {
                    appVM.showDialog = false
                }
            }, content: appVM.bodyDialog)
        }
    }
}

struct CustomDialogView: View {
    
    //@Binding var isActive: Bool
    @EnvironmentObject var appVM : AppViewModel
    
    let title: String
    let buttonTitle: String
    let action: () -> ()
    var content: AnyView
    
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
                .liquidGlass(intensity: 0.7)
                .onTapGesture {
                    withAnimation(.spring()) {
                        appVM.showDialog.toggle()
                    }
                }
                .ignoresSafeArea(.all)
            
            VStack {
                
                VStack {
                    Text(title)
                        .font(.system(size: 18))
                        .bold()
                    Divider()
                    content
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                // MARK: Old background
                /*
                .background(.ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
                 .overlay {
                     Button(action: {
                         action()
                     }, label: {
                         Image(systemName: "xmark")
                             .font(.title3)
                             .fontWeight(.medium)
                     })
                     .tint(.black)
                 }
                */
                // MARK: New background
                .background{
                    Color.clear
                        .liquidGlass(cornerRadius: 25, intensity: 0.1, tintColor: .white, hasShimmer: false, hasGlow: false)
                }
                .background(.ultraThinMaterial.opacity(0.9), in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                .padding(.top, 15)
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .padding(5)
                        .background{
                            Color.clear
                                .liquidGlass(cornerRadius: 25, intensity: 0.5, tintColor: .white, hasShimmer: false, hasGlow: false)
                        }
                        .onTapGesture {
                            withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0)) {
                                action()
                            }
                        }
                        .padding(.top, 5)
                }
                
                .shadow(radius: 20)
                .padding(30)
                .padding(.bottom, 50)
                .offset(x: 0, y: offset)
                .onAppear{
                    withAnimation(.spring()) {
                        offset = 0
                    }
                }
            }
        }
    }
    
    func close() {
        withAnimation(.spring()) {
            self.offset = 1000
        }
    }
}

// MARK: Get getPlayersAndTrophies by Team
extension SportDBView {
    func getPlayersAndTrophies(by team: Team) {
        Task {
            let(players, trophies) = await team.fetchPlayersAndTrophies()
            trophyListVM.setTrophyGroup(by: trophies)
            getMorePlayer(players: players)
        }
    }
    
    func getMorePlayer(players: [Player]) {
        let cleanedPlayers = players.filter { otherName in
            !playerListVM.playersByLookUpAllForaTeam.contains { fullName in
                let fulName = (fullName.player ?? "").replacingOccurrences(of: "-", with: " ")
                
                return fulName.lowercased().contains(otherName.player?.lowercased() ?? "")
            }
        }
        
        DispatchQueueManager.share.runOnMain {
            playerListVM.playersByLookUpAllForaTeam.append(contentsOf: cleanedPlayers)
        }
    }
}

struct TextFieldSearchView: View {
    //@EnvironmentObject var appVM: appv
    @State var listModels: [[Any]]
    @Binding var textSearch: String

    @State var showClear: Bool = true
    var body: some View {
        
        
        HStack{
            Image(systemName: "magnifyingglass")
                //.foregroundStyleItemView(by: appVM.appMode)
                .padding(.leading, 5)
            TextField("Enter text", text: $textSearch)
                //.foregroundStyleItemView(by: appVM.appMode)
                
            if showClear {
                if !textSearch.isEmpty {
                    Button(action: {
                        self.textSearch = ""
                        for i in 0..<listModels.count {
                            listModels[i] = []
                        }
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                    //.foregroundStyleItemView(by: appVM.appMode)
                    .padding(.trailing, 5)
                }
            }
        }
        //.avoidKeyboard()
        .padding(.vertical, 3)
        .liquidGlassBlur()
    }
}


struct NavigationToNotificationView: View {
    @EnvironmentObject var notificationListVM: NotificationListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: notificationListVM.notifications.count > 0 ? "bell.fill" : "bell")
                .font(.title3)
                .frame(width: 25, height: 25)
            Text("Notification")
                .font(.caption)
                .fontWeight(.semibold)
                //.lineLimit(1)
            
        }
        .padding(5)
        .background{
            Color.clear
                .liquidGlass(intensity: 0.3, tintColor: .orange, hasShimmer: true, hasGlow: true)
        }
        .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .onTapGesture {
            if !sportRouter.isAtNotification {
                sportRouter.navigateToNotification()
            }
        }
        .padding(.top, 5)
        .overlay(alignment: .topTrailing) {
            Color.clear
                .customBadge(notificationListVM.notifications.count)
        }
    }
}


struct NavigationToLikedView: View {
    @EnvironmentObject var eventSwiftDataVM: EventSwiftDataViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    @State private var likedCount: Int = 0
    @State private var shouldBounce: Bool = false
    
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                Image(systemName: likedCount > 0 ? "heart.fill" : "heart")
                    .font(.title3)
                    .frame(width: 25, height: 25)
                    
                Text("Favotire")
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
                if !sportRouter.isAtLike {
                    
                    sportRouter.navigateToLike()
                }
            }
        }
        .padding(.top, 5)
        .overlay(alignment: .topTrailing) {
            Color.clear
                //.customBadge(getNumberEventsLiked())
                .customBadge(likedCount)
        }
        // Listen to changes in eventSwiftDataVM.events
        .onChange(of: eventSwiftDataVM.events.map(\.like)) { oldValues, newValues in
            let newCount = newValues.filter { $0 }.count
            
            if newCount != likedCount {
                withAnimation(.easeInOut(duration: 0.3)) {
                    likedCount = newCount
                }
                
                // Trigger bounce animation
                triggerBounce()
            }
        }
        .onAppear {
            likedCount = eventSwiftDataVM.getEventsLiked().count
        }
    }
    
    func getNumberEventsLiked() -> Int {
        withAnimation {
            return eventSwiftDataVM.getEventsLiked().count
        }
        
    }
    
    private func triggerBounce() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            shouldBounce = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                shouldBounce = false
            }
        }
    }
}

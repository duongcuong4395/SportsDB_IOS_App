//
//  SportDBView.swift
//  SportsDB
//
//  Created by Macbook on 5/6/25.
//

import SwiftUI

// MARK: - Simplified ContentView
struct SportDBView: View {
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
    @StateObject private var chatVM = ChatViewModel()

    // MARK: - UI Constants
    private let badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (60, 60)
    
    @Namespace var animation
    
    
    
    var body: some View {
        VStack {
           GenericNavigationStack(
            router: sportRouter
            , rootContent: {
                ListCountryRouteView(animation: animation)
                    .background{
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
                        
                        // Particle background
                        ParticleGlass()
                            .ignoresSafeArea()
                    }
                    
            }
            , destination:
                sportDestination
                
           )
           
       }
        
        .overlay(alignment: .bottomLeading, content: {
            SelectSportView(tappedSport: { sport in
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
            })
            .padding(.horizontal, 5)
        })
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
        
        .environmentObject(chatVM)
        
        .onAppear(perform: onAppear)
    }
    
    private func onAppear() {
        chatVM.initChat()
        
    }
}


// MARK: - Navigation Destinations
private extension SportDBView {
    @ViewBuilder
    func sportDestination(_ route: SportRoute) -> some View {
        VStack {
            switch route {
            case .ListCountry:
                ListCountryRouteView(animation: animation)
            case .ListLeague(by: let country, and: let sport):
                ListLeagueRouteView(country: country, sport: sport, animation: animation)
                    .navigationBarHidden(true)
            case .LeagueDetail(by: let leagueID):
                LeagueDetailRouteView(leagueID: leagueID)
                    .navigationBarHidden(true)
            case .TeamDetail(by: _):
                VStack {
                    if let team = teamDetailVM.teamSelected {
                        TeamDetailRouteView(team: team)
                            
                    }
                }
                .padding(0)
                .navigationBarHidden(true)
                
            }
        }
        .background{
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
            
            // Particle background
            ParticleGlass()
                .ignoresSafeArea()
        }
        
    }
}

// MARK: Get getPlayersAndTrophies by Team
extension SportDBView {
    func getPlayersAndTrophies(by team: Team) {
        Task {
            let(players, trophies) = try await team.fetchPlayersAndTrophies()
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



struct ErrorStateView: View {
    let error: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            VStack(spacing: 8) {
                Text("Something went wrong")
                    .font(.headline)
                
                Text(error)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Try Again") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(40)
    }
}

struct LoadingStateView: View {
    var kindName: String
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Loading \(kindName)...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct IdleStateView: View {
    
    var kindName: String
    let onLoadTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe.americas.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 8) {
                Text("Welcome to \(kindName)")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Discover \(kindName) around the world")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Load \(kindName)") {
                onLoadTapped()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(40)
    }
}





protocol SelectTeamDelegate {
    var teamListVM: TeamListViewModel { get }
    var teamDetailVM: TeamDetailViewModel { get }
    var playerListVM: PlayerListViewModel { get }
    
    
    var trophyListVM: TrophyListViewModel { get }
    
    var sportRouter: SportRouter { get }
    
    var eventListVM: EventListViewModel { get }
    var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel { get }
    
}

extension SelectTeamDelegate {
    @MainActor
    func tapOnTeam(by event: Event, for kindTeam: KindTeam) {
        Task {
            await resetWhenTapTeam()
            
        }
        
        withAnimation {
            
            let homeVSAwayTeam = event.eventName?.split(separator: " vs ")
            let homeTeam = String(homeVSAwayTeam?[0] ?? "")
            let awayTeam = String(homeVSAwayTeam?[1] ?? "")
            let team: String = kindTeam == .AwayTeam ? awayTeam : homeTeam
            let teamID: String = kindTeam == .AwayTeam ? event.idAwayTeam ?? "" : event.idHomeTeam ?? ""
            sportRouter.navigateToTeamDetail(by: teamID)
            selectTeam(by: team)
            
        }
    }
    
    @MainActor
    func resetWhenTapTeam() async {
        withAnimation(.easeInOut(duration: 0.5)) {
            //teamDetailVM.teamSelected = nil
            trophyListVM.resetTrophies()
            playerListVM.resetPlayersByLookUpAllForaTeam()
            teamDetailVM.resetEquipment()
            //eventListVM.resetEventsOfTeamForNextAndPrevious()
        }
        return
    }
}

extension SelectTeamDelegate {
    @MainActor
    func selectTeam(by team: String) {
        Task {
            await teamListVM.searchTeams(teamName: team)
            guard teamListVM.teamsBySearch.count > 0 else { return }
            teamDetailVM.setTeam(by: teamListVM.teamsBySearch[0])
            guard let team = teamDetailVM.teamSelected else { return }
            
            eventsOfTeamByScheduleVM.selectTeam(by: team)
            
            
            await playerListVM.lookupAllPlayers(teamID: team.idTeam ?? "")
            
            await teamDetailVM.lookupEquipment(teamID: team.idTeam ?? "")
            
            getPlayersAndTrophies(by: team)
            
        }
    }
    
    @MainActor
    func getPlayersAndTrophies(by team: Team) {
        Task {
            let(players, trophies) = try await team.fetchPlayersAndTrophies()
            trophyListVM.setTrophyGroup(by: trophies)
            getMorePlayer(players: players)
        }
    }
    
    @MainActor
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
        /*
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 10, style: .continuous)
        )
         */
        //.edgesIgnoringSafeArea(.bottom)
    }
}

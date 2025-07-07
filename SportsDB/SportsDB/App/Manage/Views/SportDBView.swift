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
    
    var body: some View {
        VStack {
               GenericNavigationStack(router: sportRouter, rootContent: {
                   ListCountryRouteView(tappedCountry: handleTappedCountry)
               }, destination: sportDestination)
       }
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
    
    // MARK: - Handlers
        private func handleTappedCountry(_ country: Country) {
            UIApplication.shared.endEditing()
            countryListVM.setCountry(by: country)

            Task {
                await leagueListVM.fetchLeagues(country: country.name, sport: sportVM.sportSelected.rawValue)
                sportRouter.navigateToListLeague(by: country.name, and: sportVM.sportSelected.rawValue)
            }
        }

        private func onAppear() {
            chatVM.initChat()
            Task {
                await countryListVM.fetchCountries()
            }
        }
}


// MARK: - Navigation Destinations
private extension SportDBView {
    @ViewBuilder
    func sportDestination(_ route: SportRoute) -> some View {
        switch route {
        case .ListCountry:
            ListCountryRouteView(tappedCountry: handleTappedCountry)
        case .ListLeague(by: let country, and: let sport):
            ListLeagueRouteView(
                leagues: leagueListVM.leagues,
                badgeImageSizePerLeague: badgeImageSizePerLeague,
                tappedLeague: { league in
                    leagueDetailVM.setLeague(by: league)
                    Task {
                        await teamListVM.getListTeams(leagueName: league.leagueName ?? "", sportName: sport, countryName: country)
                        //await eventListVM.lookupEventsPastLeague(leagueID: league.idLeague ?? "")
                        await seasonListVM.getListSeasons(leagueID: league.idLeague ?? "")
                        
                        
                    }
                    eventsRecentOfLeagueVM.getEvents(by: league.idLeague ?? "")
                    sportRouter.navigateToLeagueDetail(by: league.idLeague ?? "")
                    
                })
        case .LeagueDetail(by: let leagueID):
            LeagueDetailRouteView(
                listTeamByLeagueView: buildTeamListView(),
                seasonForLeagueView: BuildSeasonForLeagueView(leagueID: leagueID),
                leagueTable: (
                    withConditions: seasonListVM.seasonSelected != nil && leagueListVM.leaguesTable.count > 0,
                    withView: BuildLeagueTableView()
                ),
                events: (
                    forPastLeague: (
                        withTheRightConditions: true,
                        withView: BuildEventsForPastLeagueView()),
                    forEachRound: (
                        inControl: (
                            withTheRightConditions: seasonListVM.seasonSelected != nil,
                            withView: BuildEventsForEachRoundInControl(leagueID: leagueID)),
                        inList: (
                            // (eventListVM.eventsByRoundAndSeason.models ?? []).count > 0
                            withTheRightConditions: true,
                            withView: BuildEventsForEachRoundView())
                    ),
                    forSpecific: (
                        // sdd
                        
                        /// eventListVM.eventsInSpecific.count > 0
                        withTheRightConditions: true,
                        withView: BuildEventsForSpecific())
                )
            )
        case .TeamDetail(by: _):
            if let team = teamDetailVM.teamSelected {
                TeamDetailRouteView(
                    team: team,
                    events: (
                        condition: true,
                        withView: BuildEventsOfTeamByScheduleView(team: team)
                    ),
                    equipments: (
                        condition: teamDetailVM.equipments.count > 0,
                        withView: EquipmentsListView(equipments: teamDetailVM.equipments)
                    ),
                    players: (
                        condition: playerListVM.playersByLookUpAllForaTeam.count > 0,
                        withMainView: BuildPlayersForTeamDetailView(team: team, progressing: false)
                    ),
                    trophies: (
                        condition: trophyListVM.trophyGroups.count > 0,
                        withView: TrophyListView(trophyGroup: trophyListVM.trophyGroups)
                    )
                )
            }
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

struct buildTeamListView: View, SelectTeamDelegate {
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventListVM: EventListViewModel
    
    private let badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (60, 60)
    var body: some View {
        TeamListView(
            teams: teamListVM.teams,
            badgeImageSizePerTeam: badgeImageSizePerLeague,
            teamTapped: { team in
                
                withAnimation {
                    teamDetailVM.teamSelected = nil
                    trophyListVM.resetTrophies()
                    playerListVM.resetPlayersByLookUpAllForaTeam()
                }
                
                teamDetailVM.setTeam(by: team)
                selectTeam(by: team.teamName)
                
                guard let team = teamDetailVM.teamSelected else { return }
                
                sportRouter.navigateToTeamDetail(by: team.idTeam ?? "")
            }
        )
    }
}





struct buildLeagueTableView: View, SelectTeamDelegate {
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    @EnvironmentObject var teamListVM: TeamListViewModel
    
    @EnvironmentObject var eventListVM: EventListViewModel
    
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    var body: some View {
        LeagueTableView(
            tappedTeam: { leagueTable in
                
                withAnimation {
                    teamDetailVM.teamSelected = nil
                    trophyListVM.resetTrophies()
                    playerListVM.resetPlayersByLookUpAllForaTeam()
                }
                
                selectTeam(by: leagueTable.teamName ?? "")
                sportRouter.navigateToTeamDetail(by: leagueTable.idTeam ?? "")
            })
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
            
            selectTeam(by: team)
            sportRouter.navigateToTeamDetail(by: teamID)
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

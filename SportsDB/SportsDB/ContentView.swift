//
//  ContentView.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var sportRouter = SportRouter()
    
    
    @StateObject var sportVM: SportViewModel = SportViewModel()
    @StateObject var countryListVM: CountryListViewModel
    @StateObject var leagueListVM: LeagueListViewModel
    @StateObject var leagueDetailVM: LeagueDetailViewModel = LeagueDetailViewModel()
    
    @StateObject var seasonListVM: SeasonListViewModel
    
    @StateObject var teamListVM: TeamListViewModel
    @StateObject var teamDetailVM: TeamDetailViewModel
    
    @StateObject var eventListVM: EventListViewModel
    
    @StateObject var playerListVM: PlayerListViewModel
    
    
    @StateObject var chatVM: ChatViewModel = ChatViewModel()
    
    var badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (width: 60, height: 60)
    
    @State var executeStatusForGetPlayes: ExecuteStatus = .Progress
    
    init() {
        // MARK: Country Management Context
        let countryRepository = CountryAPIService()
        let getAllCountriesUseCase = GetAllCountriesUseCase(repository: countryRepository)
        self._countryListVM = StateObject(wrappedValue: CountryListViewModel(
            useCase: getAllCountriesUseCase))
        
        // MARK: League Management Context
        let leagueRepository = LeagueAPIService()
        let getLeaguesUseCase = GetLeaguesUseCase(repository: leagueRepository)
        let lookupLeagueUseCase = LookupLeagueUseCase(repository: leagueRepository)
        let lookupLeagueTableUseCase = LookupLeagueTableUseCase(repository: leagueRepository)
        self._leagueListVM = StateObject(wrappedValue: LeagueListViewModel(
            getLeaguesUseCase: getLeaguesUseCase,
            lookupLeagueUseCase: lookupLeagueUseCase,
            lookupLeagueTableUseCase: lookupLeagueTableUseCase))
        
        // MARK: Season Management Context
        let seasonRepository = SeasonAPIService()
        let getListSeasonsUseCase = GetListSeasonsUseCase(repository: seasonRepository)
        self._seasonListVM = StateObject(wrappedValue: SeasonListViewModel(
            getListSeasonsUseCase: getListSeasonsUseCase))
        
        // MARK: Team Management Context
        let teamRepository = TeamAPIService()
        let getListTeamsUseCase = GetListTeamsUseCase(repository: teamRepository)
        let searchTeamsUseCase = SearchTeamsUseCase(repository: teamRepository)
        self._teamListVM = StateObject(wrappedValue: TeamListViewModel(
            getListTeamsUseCase: getListTeamsUseCase,
            searchTeamsUseCase: searchTeamsUseCase))
        
        let lookupEquipmentUseCase = LookupEquipmentUseCase(repository: teamRepository)
        self._teamDetailVM = StateObject(wrappedValue: TeamDetailViewModel(
            lookupEquipmentUseCase: lookupEquipmentUseCase))
        
        // MARK: Event Management Context
        let eventRepository = EventAPIService()
        let searchEventsUseCase = SearchEventsUseCase(repository: eventRepository)
        let lookupEventUseCase = LookupEventUseCase(repository: eventRepository)
        let lookupListEventsUseCase = LookupListEventsUseCase(repository: eventRepository)
        let lookupEventsInSpecificUseCase = LookupEventsInSpecificUseCase(repository: eventRepository)
        let lookupEventsPastLeagueUseCase = LookupEventsPastLeagueUseCase(repository: eventRepository)
        self._eventListVM = StateObject(wrappedValue: EventListViewModel(
            searchEventsUseCase: searchEventsUseCase,
            lookupEventUseCase: lookupEventUseCase,
            lookupListEventsUseCase: lookupListEventsUseCase,
            lookupEventsInSpecificUseCase: lookupEventsInSpecificUseCase,
            lookupEventsPastLeagueUseCase: lookupEventsPastLeagueUseCase))
        
        
        let playerRepository = PlayerAPIService()
        
        let lookupPlayerUseCase = LookupPlayerUseCase(repository: playerRepository)
        let searchPlayersUseCase = SearchPlayersUseCase(repository: playerRepository)
        let lookupHonoursUseCase = LookupHonoursUseCase(repository: playerRepository)
        let lookupFormerTeamsUseCase = LookupFormerTeamsUseCase(repository: playerRepository)
        let lookupMilestonesUseCase = LookupMilestonesUseCase(repository: playerRepository)
        let lookupContractsUseCase = LookupContractsUseCase(repository: playerRepository)
        let lookupAllPlayersUseCase = LookupAllPlayersUseCase(repository: playerRepository)
        self._playerListVM = StateObject(wrappedValue: PlayerListViewModel(
            lookupPlayerUseCase: lookupPlayerUseCase,
            searchPlayersUseCase: searchPlayersUseCase,
            lookupHonoursUseCase: lookupHonoursUseCase,
            lookupFormerTeamsUseCase: lookupFormerTeamsUseCase,
            lookupMilestonesUseCase: lookupMilestonesUseCase,
            lookupContractsUseCase: lookupContractsUseCase,
            lookupAllPlayersUseCase: lookupAllPlayersUseCase))
    }
    
    var body: some View {
        VStack {
            GenericNavigationStack(router: sportRouter, rootContent: {
                ListCountryRouteView(tappedCountry: { country in
                    UIApplication.shared.endEditing()
                    countryListVM.setCountry(by: country)
                    
                    Task {
                        await leagueListVM.fetchLeagues(country: country.name, sport: sportVM.sportSelected.rawValue)
                        sportRouter.navigateToListLeague(by: countryListVM.countrySelected?.name ?? "", and: sportVM.sportSelected.rawValue)
                    }
                })
            }, destination: { route in
                sportDestination(route)
            })
        }
        .environmentObject(sportVM)
        .environmentObject(countryListVM)
        .environmentObject(leagueListVM)
        .environmentObject(leagueDetailVM)
        .environmentObject(seasonListVM)
        .environmentObject(teamListVM)
        .environmentObject(teamDetailVM)
        .environmentObject(playerListVM)
        
        .environmentObject(chatVM)
        
        .onAppear(perform: {
            //chatVM.initializeChat()
            chatVM.initChat()
            
            Task {
                await countryListVM.fetchCountries()
            }
            
        })
    }
}


extension ContentView{
    @ViewBuilder
    private func sportDestination(_ route: SportRoute) -> some View {
        switch route {
        case .ListCountry:
            ListCountryRouteView(tappedCountry: { country in
                UIApplication.shared.endEditing()
                countryListVM.setCountry(by: country)
                
                Task {
                    await leagueListVM.fetchLeagues(country: country.name, sport: sportVM.sportSelected.rawValue)
                    sportRouter.navigateToListLeague(by: countryListVM.countrySelected?.name ?? "", and: sportVM.sportSelected.rawValue)
                }
                
            })
        case .ListLeague(by: let countryName, and: let sportName):
            ListLeagueRouteView(
                leagues: leagueListVM.leagues
                , badgeImageSizePerLeague: badgeImageSizePerLeague
                , tappedLeague: { league in
                    leagueDetailVM.setLeague(by: league)
                    Task {
                        await teamListVM.getListTeams(leagueName: league.leagueName ?? "", sportName: sportName, countryName: countryName)
                        await eventListVM.lookupEventsPastLeague(leagueID: league.idLeague ?? "")
                        await seasonListVM.getListSeasons(leagueID: league.idLeague ?? "")
                        sportRouter.navigateToLeagueDetail(by: league.idLeague ?? "")
                    }
                    
            })
        case .LeagueDetail(by: let leagueID):
            LeagueDetailRouteView(
                listTeamByLeagueView: TeamListView(
                    teams: teamListVM.teams,
                    badgeImageSizePerTeam: badgeImageSizePerLeague,
                    teamTapped: { team in
                        
                        teamDetailVM.setTeam(by: team)
                        sportRouter.navigateToTeamDetail(by: team.idTeam ?? "")
                    }
                ),
                seasonForLeagueView: SeasonForLeagueView(
                    seasons: seasonListVM.seasons,
                    seasonSelected: seasonListVM.seasonSelected,
                    tappedSeason: { season in
                        withAnimation(.spring()) {
                            eventListVM.resetEventsByLookupList()
                            eventListVM.resetEventsInSpecific()
                            leagueListVM.resetLeaguesTable()
                            
                            seasonListVM.setSeason(by: season)
                            eventListVM.setCurrentRound(by: 1)
                            
                            Task {
                                await leagueListVM.lookupLeagueTable(
                                    leagueID: leagueID,
                                    season: seasonListVM.seasonSelected?.season ?? "")
                                
                                await eventListVM.lookupListEvents(
                                    leagueID: leagueID,
                                    round: "\(eventListVM.currentRound)",
                                    season: seasonListVM.seasonSelected?.season ?? "")
                                
                                await eventListVM.lookupEventsInSpecific(
                                    leagueID: leagueID,
                                    season: seasonListVM.seasonSelected?.season ?? "")
                            }
                        }
                        
                    }),
                leagueTable: (
                    withConditions: seasonListVM.seasonSelected != nil && leagueListVM.leaguesTable.count > 0,
                    withView:  LeagueTableView(
                        leagueTables: leagueListVM.leaguesTable,
                        tappedTeam: { leagueTable in
                            
                        })
                ),
                events: (
                    forPastLeague: (
                        withTheRightConditions: true,
                        withView: ListEventView(
                            events: eventListVM.eventsPastLeague,
                            optionEventView: getEventOptionsView,
                            homeTeamTapped: tapOnHomeTeam,
                            awayTeamTapped: { event in },
                            eventTapped: { event in })
                    ),
                    forEachRound: (
                        inControl: (
                            withTheRightConditions: seasonListVM.seasonSelected != nil,
                            withView: PreviousAndNextRounrEventView(
                                currentRound: eventListVM.currentRound,
                                hasNextRound: eventListVM.hasNextRound,
                                nextRoundTapped: {
                                    eventListVM.setNextCurrentRound()
                                    Task {
                                        await eventListVM.lookupListEvents(
                                            leagueID: leagueID,
                                            round: "\(eventListVM.currentRound)",
                                            season: seasonListVM.seasonSelected?.season ?? "")
                                    }
                                },
                                previousRoundTapped: {
                                    eventListVM.setPreviousCurrentRound()
                                    Task {
                                        await eventListVM.lookupListEvents(
                                            leagueID: leagueID,
                                            round: "\(eventListVM.currentRound)",
                                            season: seasonListVM.seasonSelected?.season ?? "")
                                    }
                                })
                        ),
                        inList: (
                            withTheRightConditions: eventListVM.eventsByLookupList.count > 0,
                            withView: ListEventView(
                                events: eventListVM.eventsByLookupList,
                                optionEventView: getEventOptionsView,
                                homeTeamTapped: tapOnHomeTeam,
                                awayTeamTapped: { event in },
                                eventTapped: { event in }))
                    ),
                    forSpecific: (
                        withTheRightConditions: eventListVM.eventsInSpecific.count > 0,
                        withView: ListEventView(
                            events: eventListVM.eventsInSpecific,
                            optionEventView: getEventOptionsView,
                            homeTeamTapped: tapOnHomeTeam,
                            awayTeamTapped: { event in },
                            eventTapped: { event in })
                    )
                )
            )
            
        case .TeamDetail(by: let teamID):
            if let team = teamDetailVM.teamSelected {
                TeamDetailRouteView(
                    team: team,
                    players: (
                        withMainView: PlayerListView(players: playerListVM.playersByLookUpAllForaTeam),
                        withMorePlayersView: VStack {
                            switch executeStatusForGetPlayes {
                            case .Done:
                                MorePlayersView(players: playerListVM.playersByAI, team: team)
                            default:
                                ProgressView()
                            }
                        }
                    )
                )
                .onAppear{
                getPlayers(by: team)
                }
            }
        }
    }
    
    
    
    func getPlayers(by team: Team) {
        executeStatusForGetPlayes = .Progress
        team.fetchPlayersAndTrophies(chatVM: chatVM) { trophyGroups, players in
            
            let playersNameFromLookup = playerListVM.playersByLookUpAllForaTeam.map { $0.player ?? "" }
            let playersByAI = players.map{ $0.name }
            print("=== playersNameFromLookup ", playersNameFromLookup)
            print("=== playersByAI ", playersByAI)
            
            let cleanedPlayers = playersByAI.filter { otherName in
                !playersNameFromLookup.contains { fullName in
                    // loại bỏ nếu trùng chính xác, hoặc là 1 phần của full name (so sánh không phân biệt hoa thường)
                    fullName.lowercased().contains(otherName.lowercased())
                }
            }

            print("=== cleanedPlayers", cleanedPlayers)
            //self.players =  Array(players.prefix(25)) // [players[0]]
            
            
            DispatchQueueManager.share.runOnMain {
                playerListVM.playersByAI = cleanedPlayers.map { name in
                    PlayersAIResponse(name: name)
                }
                executeStatusForGetPlayes = .Done
            }
            
        }
    }
    
    @ViewBuilder
    func getEventOptionsView(event: Event) -> some View {
        EventOptionsView(event: event) { action, event in
            switch action {
            case .toggleFavorite:
                print("=== event:toggleFavorite:", event.eventName ?? "")
            case .toggleNotify:
                print("=== event:toggleNotify:", event.eventName ?? "")
            case .openPlayVideo:
                print("=== event:openPlayVideo:", event.eventName ?? "")
            case .viewDetail:
                print("=== event:viewDetail:", event.eventName ?? "")
            case .pushFireBase:
                print("=== event:pushFireBase:", event.eventName ?? "")
            case .selected:
                print("=== event:selected:", event.eventName ?? "")
            case .drawOnMap:
                print("=== event:drawOnMap:", event.eventName ?? "")
            }
        }
    }
    
    func tapOnHomeTeam(by event: Event) {
        withAnimation {
            
            print("=== tapOnHomeTeam.event", event.eventName ?? "", event.homeTeam ?? "", event.idHomeTeam ?? "")
            let homeVSAwayTeam = event.eventName?.split(separator: " vs ")
            let homeTeam = String(homeVSAwayTeam?[0] ?? "")
            let awayTeam = String(homeVSAwayTeam?[1] ?? "")
            
            
            
            Task {
                
                await teamListVM.searchTeams(teamName: homeTeam)
                let names = teamListVM.teamsBySearch.map { $0.teamName }
                guard teamListVM.teamsBySearch.count > 0 else { return }
                
                teamDetailVM.setTeam(by: teamListVM.teamsBySearch[0])
                
                guard let team = teamDetailVM.teamSelected else { return }
                
                await playerListVM.lookupAllPlayers(teamID: team.idTeam ?? "")
                
                sportRouter.navigateToTeamDetail(by: team.idTeam ?? "")
            }
            
        }
        
    }
}


enum ExecuteStatus {
    case Done
    case Progress
    case Fail
}

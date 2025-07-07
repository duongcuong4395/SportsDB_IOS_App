//
//  ContentView.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import SwiftUI

/*
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
    @StateObject var trophyListVM: TrophyListViewModel = TrophyListViewModel()
    
    @StateObject var chatVM: ChatViewModel = ChatViewModel()
    
    
    
    var badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (width: 60, height: 60)
    
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
        let getEventsOfTeamByScheduleUseCase = GetEventsOfTeamByScheduleUseCase(repository: eventRepository)
        self._eventListVM = StateObject(wrappedValue: EventListViewModel(
            searchEventsUseCase: searchEventsUseCase,
            lookupEventUseCase: lookupEventUseCase,
            lookupListEventsUseCase: lookupListEventsUseCase,
            lookupEventsInSpecificUseCase: lookupEventsInSpecificUseCase,
            lookupEventsPastLeagueUseCase: lookupEventsPastLeagueUseCase,
            getEventsOfTeamByScheduleUseCase: getEventsOfTeamByScheduleUseCase))
        
        
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
            GenericNavigationStack(
                router: sportRouter,
                rootContent: {
                    
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
        .environmentObject(trophyListVM)
        .environmentObject(eventListVM)
        
        .environmentObject(chatVM)
        
        .onAppear(perform: {
            chatVM.initChat()
            Task {
                await countryListVM.fetchCountries()
            }
            
        })
    }
}

// MARK: Sport Destination
extension ContentView {
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
                ),
                seasonForLeagueView: SeasonForLeagueView(
                    tappedSeason: { season in
                        withAnimation(.spring()) {
                            Task {
                                await eventListVM.resetEventsByRoundAndSeason()
                                await seasonListVM.setSeason(by: season)
                            }
                            
                            eventListVM.resetEventsInSpecific()
                            leagueListVM.resetLeaguesTable()
                            
                            
                            eventListVM.setCurrentRound(by: 1)
                            
                            Task {
                                await leagueListVM.lookupLeagueTable(
                                    leagueID: leagueID,
                                    season: seasonListVM.seasonSelected?.season ?? "")
                                
                                eventListVM.getEventsByRoundAndSeason(
                                    leagueID: leagueID,
                                    round: "\(eventListVM.currentRound)",
                                    season: seasonListVM.seasonSelected?.season ?? "")
                                /*
                                await eventListVM.lookupListEvents(
                                    leagueID: leagueID,
                                    round: "\(eventListVM.currentRound)",
                                    season: seasonListVM.seasonSelected?.season ?? "")
                                */
                                await eventListVM.lookupEventsInSpecific(
                                    leagueID: leagueID,
                                    season: seasonListVM.seasonSelected?.season ?? "")
                            }
                        }
                        
                    }),
                leagueTable: (
                    withConditions: seasonListVM.seasonSelected != nil && leagueListVM.leaguesTable.count > 0,
                    withView:  LeagueTableView(
                        tappedTeam: { leagueTable in
                            
                            withAnimation {
                                teamDetailVM.teamSelected = nil
                                trophyListVM.resetTrophies()
                                playerListVM.resetPlayersByLookUpAllForaTeam()
                            }
                            
                            selectTeam(by: leagueTable.teamName ?? "")
                            sportRouter.navigateToTeamDetail(by: leagueTable.idTeam ?? "")
                        })
                ),
                events: (
                    forPastLeague: (
                        withTheRightConditions: true,
                        withView: ListEventView(
                            events: eventListVM.eventsPastLeague,
                            optionEventView: getEventOptionsView,
                            tapOnTeam: tapOnTeam,
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
                                    eventListVM.getEventsByRoundAndSeason(
                                        leagueID: leagueID,
                                        round: "\(eventListVM.currentRound)",
                                        season: seasonListVM.seasonSelected?.season ?? "")
                                    Task {
                                        
                                        /*
                                        await eventListVM.lookupListEvents(
                                            leagueID: leagueID,
                                            round: "\(eventListVM.currentRound)",
                                            season: seasonListVM.seasonSelected?.season ?? "")
                                         */
                                    }
                                },
                                previousRoundTapped: {
                                    eventListVM.setPreviousCurrentRound()
                                    eventListVM.getEventsByRoundAndSeason(
                                        leagueID: leagueID,
                                        round: "\(eventListVM.currentRound)",
                                        season: seasonListVM.seasonSelected?.season ?? "")
                                    Task {
                                        
                                        /*
                                        await eventListVM.lookupListEvents(
                                            leagueID: leagueID,
                                            round: "\(eventListVM.currentRound)",
                                            season: seasonListVM.seasonSelected?.season ?? "")
                                         */
                                    }
                                })
                        ),
                        inList: (
                            withTheRightConditions: (eventListVM.eventsByRoundAndSeason.models ?? []).count > 0,
                            withView: ListEventView(
                                events: eventListVM.eventsByRoundAndSeason.models ?? [],
                                optionEventView: getEventOptionsView,
                                tapOnTeam: tapOnTeam,
                                eventTapped: { event in }))
                    ),
                    forSpecific: (
                        withTheRightConditions: eventListVM.eventsInSpecific.count > 0,
                        withView: ListEventView(
                            events: eventListVM.eventsInSpecific,
                            optionEventView: getEventOptionsView,
                            tapOnTeam: tapOnTeam,
                            eventTapped: { event in })
                    )
                )
            )
            
        case .TeamDetail(by: let teamID):
            if let team = teamDetailVM.teamSelected {
                TeamDetailRouteView(
                    team: team,
                    events: (
                        condition: true,
                        withView: EventsOfTeamByScheduleView(
                            team: team,
                            optionEventView: getEventOptionsView,
                            tapOnTeam: { event, kindTeam in
                                tapOnTeamForReplace(by: event, for: kindTeam)
                                
                                sportRouter.navigateToReplaceTeamDetail(by: teamID)
                            },
                            eventTapped: { event in })
                    ),
                    equipments: (
                        condition: true,
                        withView: EquipmentsListView(equipments: teamDetailVM.equipments)
                    ),
                    players: (
                        condition: true,
                        withMainView: EmptyView()
                        /*
                            HStack {
                                PlayerListView(players: playerListVM.playersByLookUpAllForaTeam, refreshPlayer: { player in
                                    Task {
                                        
                                        
                                        let playersSearch = await playerListVM.searchPlayers(by: player.player ?? "")
                                        if let playerF = playersSearch.first(where: { $0.team ?? ""  == team.teamName }) {
                                            print("=== playerF", playerF.player ?? "", playerF.idPlayer ?? "")
                                            
                                            if let id = playerF.idPlayer {
                                                let players = await playerListVM.lookupPlayer(by: id)
                                                if players.count > 0 {
                                                    guard let index = playerListVM.playersByLookUpAllForaTeam.firstIndex(where: { $0.player == player.player }) else { return }
                                                    playerListVM.playersByLookUpAllForaTeam[index] = players[0]
                                                    //self.player = players[0]
                                                } else {
                                                    //self.player = Player(player: playerName)
                                                }
                                            }
                                        }
                                    }
                                })
                                
                                if executeStatusForGetPlayes == .Progress {
                                    ProgressView()
                                        .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                                }
                            }
                        */
                    ),
                    trophies: (
                        condition: true,
                        withView: TrophyListView(trophyGroup: trophyListVM.trophyGroups)
                            .frame(height: UIScreen.main.bounds.height/2)
                    )
                )
                .onAppear{
                    //getPlayersAndTrophies(by: team)
                }
            }
        }
    }
}


// MARK: Get getPlayersAndTrophies by Team
extension ContentView {
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


// MARK: Options For Event Item View
extension ContentView {
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
    
    func resetWhenTapTeam() {
        withAnimation {
            teamDetailVM.teamSelected = nil
            trophyListVM.resetTrophies()
            playerListVM.resetPlayersByLookUpAllForaTeam()
            teamDetailVM.resetEquipment()
        }
    }
    
    func tapOnTeam(by event: Event, for kindTeam: KindTeam) {
        resetWhenTapTeam()
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
    
    func tapOnTeamForReplace(by event: Event, for kindTeam: KindTeam) {
        resetWhenTapTeam()
        withAnimation {
            
            print("=== tapOnHomeTeam.event", event.eventName ?? "", event.homeTeam ?? "", event.idHomeTeam ?? "")
            let homeVSAwayTeam = event.eventName?.split(separator: " vs ")
            let homeTeam = String(homeVSAwayTeam?[0] ?? "")
            let awayTeam = String(homeVSAwayTeam?[1] ?? "")
            let team: String = kindTeam == .AwayTeam ? awayTeam : homeTeam
            //let teamID: String = kindTeam == .AwayTeam ? event.idAwayTeam ?? "" : event.idHomeTeam ?? ""
            
            selectTeam(by: team)
        }
    }
    
    func selectTeam(by team: String) {
        Task {
            
            await teamListVM.searchTeams(teamName: team)
            
            guard teamListVM.teamsBySearch.count > 0 else { return }
            
            teamDetailVM.setTeam(by: teamListVM.teamsBySearch[0])
            
            guard let team = teamDetailVM.teamSelected else { return }
            
            self.eventListVM.eventsOfTeamForNext.models = await eventListVM.getEventsOfTeamBySchedule(of: team.idTeam ?? "", by: .Next)
            self.eventListVM.eventsOfTeamForPrevious.models = await eventListVM.getEventsOfTeamBySchedule(of: team.idTeam ?? "", by: .Previous)
            
            await playerListVM.lookupAllPlayers(teamID: team.idTeam ?? "")
            
            await teamDetailVM.lookupEquipment(teamID: team.idTeam ?? "")
            
            getPlayersAndTrophies(by: team)
            
        }
    }
    
}
*/







// MARK: New 

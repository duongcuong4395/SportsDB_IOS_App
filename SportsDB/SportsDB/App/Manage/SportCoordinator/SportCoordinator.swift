//
//  SportCoordinator.swift
//  SportsDB
//
//  Created by Macbook on 5/6/25.
//

import SwiftUI

/*
// MARK: - Sport Coordinator
@MainActor
class SportCoordinator: ObservableObject {
    private let container: DependencyContainer
    
    // Core ViewModels
    @Published var sportVM = SportViewModel()
    @Published var countryListVM: CountryListViewModel
    @Published var leagueListVM: LeagueListViewModel
    @Published var leagueDetailVM = LeagueDetailViewModel()
    @Published var seasonListVM: SeasonListViewModel
    @Published var teamListVM: TeamListViewModel
    @Published var teamDetailVM: TeamDetailViewModel
    @Published var eventListVM: EventListViewModel
    @Published var playerListVM: PlayerListViewModel
    @Published var trophyListVM = TrophyListViewModel()
    @Published var chatVM = ChatViewModel()
    
    // UI State
    @Published var executeStatusForGetPlayers: ExecuteStatus = .Progress
    
    init(container: DependencyContainer = DependencyContainer()) {
        self.container = container
        
        // Initialize ViewModels using the container
        self.countryListVM = container.makeCountryListViewModel()
        self.leagueListVM = container.makeLeagueListViewModel()
        self.seasonListVM = container.makeSeasonListViewModel()
        self.teamListVM = container.makeTeamListViewModel()
        self.teamDetailVM = container.makeTeamDetailViewModel()
        self.eventListVM = container.makeEventListViewModel()
        self.playerListVM = container.makePlayerListViewModel()
    }
    
    // MARK: - Business Logic Methods
    func initializeApp() async {
        chatVM.initChat()
        await countryListVM.fetchCountries()
    }
    
    func selectCountry(_ country: Country) async {
        countryListVM.setCountry(by: country)
        await leagueListVM.fetchLeagues(
            country: country.name,
            sport: sportVM.sportSelected.rawValue
        )
    }
    
    func selectLeague(_ league: League, sportName: String, countryName: String) async {
        leagueDetailVM.setLeague(by: league)
        
        async let teamsTask: () = teamListVM.getListTeams(
            leagueName: league.leagueName ?? "",
            sportName: sportName,
            countryName: countryName
        )
        async let eventsTask: () = eventListVM.lookupEventsPastLeague(
            leagueID: league.idLeague ?? ""
        )
        async let seasonsTask: () = seasonListVM.getListSeasons(
            leagueID: league.idLeague ?? ""
        )
        
        // Wait for all tasks to complete
        _ = await (teamsTask, eventsTask, seasonsTask)
    }
    
    func selectSeason(_ season: Season, leagueID: String) async {
        // Reset related state
        eventListVM.resetEventsByLookupList()
        eventListVM.resetEventsInSpecific()
        leagueListVM.resetLeaguesTable()
        
        seasonListVM.setSeason(by: season)
        eventListVM.setCurrentRound(by: 1)
        
        async let tableTask: () = leagueListVM.lookupLeagueTable(
            leagueID: leagueID,
            season: season.season
        )
        async let eventsTask: () = eventListVM.lookupListEvents(
            leagueID: leagueID,
            round: "\(eventListVM.currentRound)",
            season: season.season
        )
        async let specificEventsTask: () = eventListVM.lookupEventsInSpecific(
            leagueID: leagueID,
            season: season.season
        )
        
        _ = await (tableTask, eventsTask, specificEventsTask)
    }
    
    func selectTeam(by teamName: String) async {
        await teamListVM.searchTeams(teamName: teamName)
        
        guard let team = teamListVM.teamsBySearch.first else { return }
        
        teamDetailVM.setTeam(by: team)
        
        guard let selectedTeam = teamDetailVM.teamSelected else { return }
        
        // Fetch team-related data concurrently
        async let nextEventsTask = eventListVM.getEventsOfTeamBySchedule(
            of: selectedTeam.idTeam ?? "",
            by: .Next
        )
        async let previousEventsTask = eventListVM.getEventsOfTeamBySchedule(
            of: selectedTeam.idTeam ?? "",
            by: .Previous
        )
        async let playersTask = playerListVM.lookupAllPlayers(
            by: selectedTeam.idTeam ?? ""
        )
        async let equipmentTask: () = teamDetailVM.lookupEquipment(
            teamID: selectedTeam.idTeam ?? ""
        )
        
        let (players, nextEvents, previousEvents, _) = await (
            playersTask, nextEventsTask, previousEventsTask, equipmentTask
        )
        
        playerListVM.playersByLookUpAllForaTeam = players
        
        eventListVM.eventsOfTeamForNext = nextEvents
        eventListVM.eventsOfTeamForPrevious = previousEvents
        
        await fetchPlayersAndTrophies(for: selectedTeam)
    }
    
    private func fetchPlayersAndTrophies(for team: Team) async {
        executeStatusForGetPlayers = .Progress
        
        do {
            let (players, trophies) = try await team.fetchPlayersAndTrophies()
            trophyListVM.setTrophyGroup(by: trophies)
            updatePlayersList(with: players)
            executeStatusForGetPlayers = .Done
        } catch {
            executeStatusForGetPlayers = .Fail
        }
    }
    
    private func updatePlayersList(with players: [Player]) {
        let cleanedPlayers = players.filter { newPlayer in
            !playerListVM.playersByLookUpAllForaTeam.contains { existingPlayer in
                let existingName = (existingPlayer.player ?? "").replacingOccurrences(of: "-", with: " ")
                return existingName.lowercased().contains(newPlayer.player?.lowercased() ?? "")
            }
        }
        
        playerListVM.playersByLookUpAllForaTeam.append(contentsOf: cleanedPlayers)
    }
    
    func resetTeamSelection() {
        self.teamDetailVM.teamSelected = nil
        self.trophyListVM.resetTrophies()
        self.playerListVM.resetPlayersByLookUpAllForaTeam()
        self.teamDetailVM.resetEquipment()
    }
    
    func refreshPlayer(_ player: Player) async {
        guard let team = teamDetailVM.teamSelected else { return }
        
        let playersSearch = await playerListVM.searchPlayers(by: player.player ?? "")
        
        if let foundPlayer = playersSearch.first(where: { $0.team ?? "" == team.teamName }),
           let playerID = foundPlayer.idPlayer {
            
            let detailedPlayers = await playerListVM.lookupPlayer(by: playerID)
            
            if let detailedPlayer = detailedPlayers.first,
               let index = playerListVM.playersByLookUpAllForaTeam.firstIndex(where: { $0.player == player.player }) {
                playerListVM.playersByLookUpAllForaTeam[index] = detailedPlayer
            }
        }
    }
    
    func handleEventAction(_ action: EventAction, for event: Event) {
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


// MARK: - Optimized SportCoordinator Methods
extension SportCoordinator {
    
    // Optimized team selection with better error handling
    func selectTeamOptimized(by teamName: String) async {
        executeStatusForGetPlayers = .Progress
        
        do {
            await teamListVM.searchTeams(teamName: teamName)
            
            guard let team = teamListVM.teamsBySearch.first else {
                executeStatusForGetPlayers = .Fail
                return
            }
            
            teamDetailVM.setTeam(by: team)
            
            guard let selectedTeam = teamDetailVM.teamSelected else {
                executeStatusForGetPlayers = .Fail
                return
            }
            
            // Use TaskGroup for better concurrency management
            await withTaskGroup(of: Void.self) { group in
                // Add tasks to the group
                group.addTask {
                    let nextEvents = await self.eventListVM.getEventsOfTeamBySchedule(
                        of: selectedTeam.idTeam ?? "",
                        by: .Next
                    )
                    await MainActor.run {
                        self.eventListVM.eventsOfTeamForNext = nextEvents
                    }
                }
                
                group.addTask {
                    let previousEvents = await self.eventListVM.getEventsOfTeamBySchedule(
                        of: selectedTeam.idTeam ?? "",
                        by: .Previous
                    )
                    await MainActor.run {
                        self.eventListVM.eventsOfTeamForPrevious = previousEvents
                    }
                }
                
                group.addTask {
                    let players = await self.playerListVM.lookupAllPlayers(
                        by: selectedTeam.idTeam ?? ""
                    )
                    await MainActor.run {
                        self.playerListVM.playersByLookUpAllForaTeam = players
                    }
                }
                
                group.addTask {
                    await self.teamDetailVM.lookupEquipment(
                        teamID: selectedTeam.idTeam ?? ""
                    )
                }
                
                // Wait for all tasks to complete
                for await _ in group {}
            }
            
            // Fetch additional data
            await fetchPlayersAndTrophiesOptimized(for: selectedTeam)
            
        } catch {
            executeStatusForGetPlayers = .Fail
            print("Error selecting team: \(error)")
        }
    }
    
    private func fetchPlayersAndTrophiesOptimized(for team: Team) async {
        do {
            let (players, trophies) = try await team.fetchPlayersAndTrophies()
            
            await MainActor.run {
                self.trophyListVM.setTrophyGroup(by: trophies)
                self.updatePlayersListOptimized(with: players)
                self.executeStatusForGetPlayers = .Done
            }
        } catch {
            await MainActor.run {
                self.executeStatusForGetPlayers = .Fail
            }
            print("Error fetching players and trophies: \(error)")
        }
    }
    
    private func updatePlayersListOptimized(with players: [Player]) {
        // Use Set for O(1) lookup performance
        let existingPlayerNames = Set(
            playerListVM.playersByLookUpAllForaTeam.compactMap { player in
                player.player?
                    .replacingOccurrences(of: "-", with: " ")
                    .lowercased()
            }
        )
        
        let newPlayers = players.filter { newPlayer in
            guard let playerName = newPlayer.player?.lowercased() else { return false }
            return !existingPlayerNames.contains { existingName in
                existingName.contains(playerName)
            }
        }
        
        playerListVM.playersByLookUpAllForaTeam.append(contentsOf: newPlayers)
    }
}
*/

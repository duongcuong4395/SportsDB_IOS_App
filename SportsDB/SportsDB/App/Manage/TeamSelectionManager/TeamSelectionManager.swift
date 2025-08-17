//
//  TeamSelectionManager.swift
//  SportsDB
//
//  Created by Macbook on 16/8/25.
//

import SwiftUI

// MARK: - Services Layer
protocol TeamSelectionService {
    func selectTeam(by name: String) async throws
    func resetTeamData() async
}

protocol TeamDataService {
    func fetchTeamData(for team: Team) async throws
    func fetchEquipments(for teamID: String) async throws
    func fetchEvents(for team: Team) async throws
    func fetchPlayersAndTrophies(for team: Team) async throws
}


@MainActor
class TeamSelectionManager: ObservableObject, TeamSelectionService {
    
    
    private let teamListVM: TeamListViewModel
    private let teamDetailVM: TeamDetailViewModel
    private let playerListVM: PlayerListViewModel
    private let trophyListVM: TrophyListViewModel
    private let eventListVM: EventListViewModel
    private let eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    private let router: SportRouter
    
    init(
        teamListVM: TeamListViewModel,
        teamDetailVM: TeamDetailViewModel,
        playerListVM: PlayerListViewModel,
        trophyListVM: TrophyListViewModel,
        eventListVM: EventListViewModel,
        eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel,
        router: SportRouter
    ) {
        self.teamListVM = teamListVM
        self.teamDetailVM = teamDetailVM
        self.playerListVM = playerListVM
        self.trophyListVM = trophyListVM
        self.eventListVM = eventListVM
        self.eventsOfTeamByScheduleVM = eventsOfTeamByScheduleVM
        self.router = router
    }
    
    /*
    func handleTapOnTeam(by event: Event, with kindTeam: KindTeam) async throws {
        let homeVSAwayTeam = event.eventName?.split(separator: " vs ")
        let homeTeam = String(homeVSAwayTeam?[0] ?? "")
        let awayTeam = String(homeVSAwayTeam?[1] ?? "")
        let teamName: String = kindTeam == .AwayTeam ? awayTeam : homeTeam
        
        
        if let teamSelected = teamDetailVM.teamSelected
            , teamSelected.teamName == teamName {
            return
        }
        
        resetWhenTapTeam()
        try await selectTeam(by: teamName)
    }
    */
    
    func handleTapOnTeam(by event: Event, with kindTeam: KindTeam) async throws {
        let teamName = extractTeamName(from: event, kindTeam: kindTeam)
        
        guard shouldSelectNewTeam(teamName) else { return }
        
        resetTeamData()
        try await selectTeam(by: teamName)
    }
    
    func selectTeam(by teamName: String) async throws {
        guard let team = await findTeam(by: teamName) else {
            throw TeamSelectionError.teamNotFound
        }
        
        teamDetailVM.setTeam(by: team)
        
        if !router.isAtTeamDetail() {
            router.navigateToTeamDetail()
        }
        
        try await fetchAllTeamData(for: team)
        
    }
    
    func resetTeamData() {
        withAnimation(.spring()) {
            eventsOfTeamByScheduleVM.resetAll()
            trophyListVM.resetTrophies()
            playerListVM.resetPlayersByLookUpAllForaTeam()
            teamDetailVM.resetEquipment()
        }
    }
    
    // MARK: - Private Methods
    private func extractTeamName(from event: Event, kindTeam: KindTeam) -> String {
        let homeVSAwayTeam = event.eventName?.split(separator: " vs ")
        let homeTeam = String(homeVSAwayTeam?.first ?? "")
        let awayTeam = String(homeVSAwayTeam?.last ?? "")
        return kindTeam == .AwayTeam ? awayTeam : homeTeam
    }
    
    private func shouldSelectNewTeam(_ teamName: String) -> Bool {
        guard let currentTeam = teamDetailVM.teamSelected else { return true }
        return currentTeam.teamName != teamName
    }
    
    private func findTeam(by name: String) async -> Team? {
        await teamListVM.searchTeams(teamName: name)
        return teamListVM.teamsBySearch.first
    }
    
    private func fetchAllTeamData(for team: Team) async throws {
        
        async let playersTask: () = self.fetchPlayersAndTrophies(for: team)
        async let equipmentsTask: () = self.fetchEquipments(for: team.idTeam ?? "")
        async let eventsTask: () = self.fetchEvents(for: team)
        _ = await (playersTask, equipmentsTask, eventsTask)
        /*
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchEvents(for: team) }
            group.addTask { await self.fetchEquipments(for: team.idTeam ?? "") }
            group.addTask { await self.fetchPlayersAndTrophies(for: team) }
            
            try await group.waitForAll()
        }
         */
    }
    
    func fetchEvents(for team: Team) async {
        await eventsOfTeamByScheduleVM.getEvents(by: team)
    }
    
    func fetchEquipments(for teamID: String) async {
        await teamDetailVM.lookupEquipment(teamID: teamID)
    }
    
    func fetchPlayersAndTrophies(for team: Team) async {
        await playerListVM.lookupAllPlayers(teamID: team.idTeam ?? "")
        let (players, trophies) = await team.fetchPlayersAndTrophies()
        
        trophyListVM.setTrophyGroup(by: trophies)
        
        
        let cleanedPlayers = filterNewPlayers(players)
        playerListVM.playersByLookUpAllForaTeam.append(contentsOf: cleanedPlayers)
    }
    
    private func filterNewPlayers(_ players: [Player]) -> [Player] {
        return players.filter { player in
            let existingPlayers = playerListVM.playersByLookUpAllForaTeam
            return !existingPlayers.contains { existingPlayer in
                let cleanName = (existingPlayer.player ?? "").replacingOccurrences(of: "-", with: " ")
                return cleanName.lowercased().contains(player.player?.lowercased() ?? "")
            }
        }
    }
}

// MARK: - Error Types
enum TeamSelectionError: LocalizedError {
    case teamNotFound
    case networkError
    case invalidTeamData
    
    var errorDescription: String? {
        switch self {
        case .teamNotFound:
            return "Team not found"
        case .networkError:
            return "Network connection error"
        case .invalidTeamData:
            return "Invalid team data"
        }
    }
}

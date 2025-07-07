//
//  PlayerListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

@MainActor
class PlayerListViewModel: ObservableObject {
    
    @Published var playersByLookUp: [Player] = []
    @Published var playersByLookUpAllForaTeam: [Player] = []
    @Published var playersBySearch: [Player] = []
    
    @Published var honoursByLookUp: [Honour] = []
    @Published var formerTeamsByLookUp: [FormerTeam] = []
    @Published var milestonesByLookUp: [Milestone] = []
    @Published var contractsByLookUp: [Contract] = []
    
    @Published var playersByAI: [PlayersAIResponse] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private var lookupPlayerUseCase: LookupPlayerUseCase
    private var searchPlayersUseCase: SearchPlayersUseCase
    private var lookupHonoursUseCase: LookupHonoursUseCase
    
    private var lookupFormerTeamsUseCase: LookupFormerTeamsUseCase
    private var lookupMilestonesUseCase: LookupMilestonesUseCase
    
    private var lookupContractsUseCase: LookupContractsUseCase
    
    private var lookupAllPlayersUseCase: LookupAllPlayersUseCase
    
    init(lookupPlayerUseCase: LookupPlayerUseCase,
         searchPlayersUseCase: SearchPlayersUseCase,
         lookupHonoursUseCase: LookupHonoursUseCase,
         lookupFormerTeamsUseCase: LookupFormerTeamsUseCase,
         lookupMilestonesUseCase: LookupMilestonesUseCase,
         lookupContractsUseCase: LookupContractsUseCase,
         lookupAllPlayersUseCase: LookupAllPlayersUseCase
    ) {
        
        self.lookupPlayerUseCase = lookupPlayerUseCase
        self.searchPlayersUseCase = searchPlayersUseCase
        self.lookupHonoursUseCase = lookupHonoursUseCase
        self.lookupFormerTeamsUseCase = lookupFormerTeamsUseCase
        self.lookupMilestonesUseCase = lookupMilestonesUseCase
        self.lookupContractsUseCase = lookupContractsUseCase
        self.lookupAllPlayersUseCase = lookupAllPlayersUseCase
    }
    
    func resetPlayersByLookUpAllForaTeam() {
        playersByLookUpAllForaTeam = []
    }
    
    func lookupPlayerUseCase(playerID: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            playersByLookUp = try await lookupPlayerUseCase.execute(playerID: playerID)
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
    
    func searchPlayers(playerName: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            playersBySearch = try await searchPlayersUseCase.execute(playerName: playerName)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func searchPlayers(by playerName: String) async -> [Player] {
        isLoading = true
        defer { isLoading = false }
        do {
            return try await searchPlayersUseCase.execute(playerName: playerName)
        } catch {
            errorMessage = error.localizedDescription
            return []
        }
    }
    
    func lookupPlayer(by playerID: String) async -> [Player] {
        isLoading = true
        defer { isLoading = false }
        do {
            return try await lookupPlayerUseCase.execute(playerID: playerID)
        } catch {
            errorMessage = error.localizedDescription
            return []
        }
        
    }
    
    func lookupHonours(playerID: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            honoursByLookUp = try await lookupHonoursUseCase.execute(playerID: playerID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func lookupFormerTeams(playerID: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            formerTeamsByLookUp = try await lookupFormerTeamsUseCase.execute(playerID: playerID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
    func lookupMilestones(playerID: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            milestonesByLookUp = try await lookupMilestonesUseCase.execute(playerID: playerID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
    func lookupContracts(playerID: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            contractsByLookUp = try await lookupContractsUseCase.execute(playerID: playerID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func lookupAllPlayers(teamID: String) async {
        DispatchQueueManager.share.runOnMain {
            self.isLoading = true
        }
        
        defer {
            DispatchQueueManager.share.runOnMain {
                self.isLoading = false
            }
        }
        do {
            
            let playersResponse = try await lookupAllPlayersUseCase.execute(teamID: teamID)
            print("=== playersByLookUpAllForaTeam:", teamID, playersResponse.count)
            DispatchQueueManager.share.runOnMain {
                self.playersByLookUpAllForaTeam = playersResponse
            }
        } catch {
            DispatchQueueManager.share.runOnMain {
                self.errorMessage = error.localizedDescription
            }
            
        }
        
    }
    
    func lookupAllPlayers(by teamID: String) async -> [Player] {
        do {
            return try await lookupAllPlayersUseCase.execute(teamID: teamID)
        } catch {
            return []
        }
    }
}

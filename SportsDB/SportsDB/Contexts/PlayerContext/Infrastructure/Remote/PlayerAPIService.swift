//
//  PlayerAPIService.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import Networking

class PlayerAPIService: APIExecution, PlayerRepository {
    func lookupAllPlayers(teamID: String) async throws -> [Player] {
        
        let response: LookupAllPlayersAPIResponse = try await sendRequest(for: PlayerEndpoint<LookupAllPlayersAPIResponse>.LookupAllPlayers(teamID: teamID))
        
        guard let players = response.players else { return [] }
        
        return players.map { $0.toDomain() }
    }
    
    func lookupContracts(playerID: String) async throws -> [Contract] {
        let response: LookupContractsAPIResponse = try await sendRequest(for: PlayerEndpoint<LookupContractsAPIResponse>.LookupContracts(playerID: playerID))
        
        guard let milestones = response.contracts else { return [] }
        
        return milestones.map { $0.toDomain() }
    }
    
    func lookupMilestones(playerID: String) async throws -> [Milestone] {
        
        let response: LookupMilestonesAPIResponse = try await sendRequest(for: PlayerEndpoint<LookupMilestonesAPIResponse>.LookupMilestones(playerID: playerID))
        
        guard let milestones = response.milestones else { return [] }
        
        return milestones.map { $0.toDomain() }
    }
    
    func lookupFormerTeams(playerID: String) async throws -> [FormerTeam] {
        
        let response: LookupFormerTeamsAPIResponse = try await sendRequest(for: PlayerEndpoint<LookupFormerTeamsAPIResponse>.LookupFormerTeams(playerID: playerID))
        
        guard let formerTeams = response.formerTeams else { return [] }
        
        return formerTeams.map { $0.toDomain() }
    }
    
    func lookupHonours(playerID: String) async throws -> [Honour] {
        let response: LookupHonoursAPIResponse = try await sendRequest(for: PlayerEndpoint<LookupHonoursAPIResponse>.LookupPlayerHonours(playerID: playerID))
        
        guard let honours = response.honours else { return [] }
        
        return honours.map { $0.toDomain() }
    }
    
    func searchPlayers(playerName: String) async throws -> [Player] {
        let response: SearchPlayersAPIResponse = try await sendRequest(for: PlayerEndpoint<SearchPlayersAPIResponse>.SearchPlayers(playerName: playerName))
        
        guard let players = response.players else { return [] }
        
        return players.map { $0.toDomain() }
    }
    
    func lookupPlayerAPIResponse(playerID: String) async throws -> [Player] {
        let response: LookupPlayerAPIResponse = try await sendRequest(for: PlayerEndpoint<LookupPlayerAPIResponse>.LookupPlayerAPIResponse(playerID: playerID))
        
        guard let players = response.players else { return [] }
        
        return players.map { $0.toDomain() }
    }
    
    
}

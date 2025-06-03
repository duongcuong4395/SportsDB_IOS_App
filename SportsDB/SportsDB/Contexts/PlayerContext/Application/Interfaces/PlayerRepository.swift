//
//  PlayerRepository.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

protocol PlayerRepository {
    func searchPlayers(playerName: String) async throws -> [Player]
    func lookupPlayerAPIResponse(playerID: String) async throws -> [Player]
    
    func lookupHonours(playerID: String) async throws -> [Honour]
    
    func lookupFormerTeams(playerID: String) async throws -> [FormerTeam]
    
    func lookupMilestones(playerID: String) async throws -> [Milestone]
    
    func lookupContracts(playerID: String) async throws -> [Contract]
    
    func lookupAllPlayers(teamID: String) async throws -> [Player]
}

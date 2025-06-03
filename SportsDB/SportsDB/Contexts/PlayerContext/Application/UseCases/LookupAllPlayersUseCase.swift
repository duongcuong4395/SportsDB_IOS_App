//
//  LookupAllPlayersUseCase.swift
//  SportsDB
//
//  Created by Macbook on 2/6/25.
//

struct LookupAllPlayersUseCase {
    let repository: PlayerRepository
    
    func execute(teamID: String) async throws -> [Player] {
        try await repository.lookupAllPlayers(teamID: teamID)
    }
}

//
//  LookupPlayerFormerTeamsUseCase.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct LookupFormerTeamsUseCase {
    let repository: PlayerRepository
    
    func execute(playerID: String) async throws -> [FormerTeam] {
        try await repository.lookupFormerTeams(playerID: playerID)
    }
}

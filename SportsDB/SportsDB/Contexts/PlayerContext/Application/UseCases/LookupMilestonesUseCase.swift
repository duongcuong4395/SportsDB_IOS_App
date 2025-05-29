//
//  LookupMilestonesUseCase.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct LookupMilestonesUseCase {
    let repository: PlayerRepository
    
    func execute(playerID: String) async throws -> [Milestone] {
        try await repository.lookupMilestones(playerID: playerID)
    }
}

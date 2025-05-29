//
//  LookupHonoursUseCase.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct LookupHonoursUseCase {
    let repository: PlayerRepository
    
    func execute(playerID: String) async throws -> [Honour] {
        try await repository.lookupHonours(playerID: playerID)
    }
}

//
//  LookupPlayerUseCase.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct LookupPlayerUseCase {
    let repository: PlayerRepository
    
    func execute(playerID: String) async throws -> [Player] {
        try await repository.lookupPlayerAPIResponse(playerID: playerID)
    }
}

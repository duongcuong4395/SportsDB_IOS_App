//
//  LookupContractsUseCase.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct LookupContractsUseCase {
    let repository: PlayerRepository
    
    func execute(playerID: String) async throws -> [Contract] {
        try await repository.lookupContracts(playerID: playerID)
    }
}

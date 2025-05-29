//
//  LookupEquipmentUseCase.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct LookupEquipmentUseCase {
    let repository: TeamRepository
    
    func execute(teamID: String) async throws -> [Equipment] {
        try await repository.lookupEquipment(teamID: teamID)
    }
}

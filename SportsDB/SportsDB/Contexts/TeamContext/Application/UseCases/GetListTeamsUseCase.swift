//
//  GetListTeamsUseCase.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct GetListTeamsUseCase {
    let repository: TeamRepository
    
    func execute(leagueName: String, sportName: String, countryName: String) async throws -> [Team] {
        try await repository.getListTeamsAPIResponse(leagueName: leagueName, sportName: sportName, countryName: countryName)
    }
}

//
//  GetListSeasonsUseCase.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct GetListSeasonsUseCase {
    let repository: SeasonRepository
    
    func execute(leagueID: String) async throws -> [Season] {
        try await repository.getListSeasons(leagueID: leagueID)
    }
}

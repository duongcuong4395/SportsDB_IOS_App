//
//  LookupLeagueTableUseCase.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

struct LookupLeagueTableUseCase {
    let repository: LeagueRepository
    
    func execute(league_ID: String, season: String) async throws -> [LeagueTable] {
        return try await repository.lookupLeagueTable(league_ID: league_ID, season: season)
    }
}

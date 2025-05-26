//
//  GetLeaguesByCountryAndSportUseCase.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// Get all leagues by country + sport
struct GetLeaguesByCountryAndSportUseCase {
    let repository: LeagueRepository

    func execute(country: String, sport: String) async throws -> [League] {
        try await repository.getLeagues(country: country, sport: sport)
    }
}

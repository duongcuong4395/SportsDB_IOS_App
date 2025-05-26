//
//  GetLeaguesByCountryUseCase.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// Get all leagues by country
struct GetLeaguesByCountryUseCase {
    let repository: LeagueRepository

    func execute(country: String) async throws -> [League] {
        try await repository.getLeagues(country: country)
    }
}




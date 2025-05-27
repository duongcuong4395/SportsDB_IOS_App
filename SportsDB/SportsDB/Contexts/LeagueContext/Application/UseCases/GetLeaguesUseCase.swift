//
//  GetLeaguesUseCase.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//


import Foundation

struct GetLeaguesUseCase {
    let repository: LeagueRepository

    func execute(country: String, sport: String) async throws -> [League] {
        try await repository.getLeagues(country: country, sport: sport)
    }
}

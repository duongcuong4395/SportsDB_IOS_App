//
//  LeagueAPIService.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// LeagueContext/Infrastructure/Remote/LeagueAPIService.swift
final class LeagueAPIService: LeagueRepository, APIExecution {

    func getLeagues(country: String, sport: String) async throws -> [League] {
        let response: LeaguesInACountryAPIResponse = try await sendRequest(for: LeagueEndpoint<LeaguesInACountryAPIResponse>.GetLeagues(from: country, by: sport))
        
        return response.Leagues.map { $0.toDomain() }
    }
}


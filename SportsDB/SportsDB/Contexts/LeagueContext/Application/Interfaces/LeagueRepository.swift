//
//  LeagueRepository.swift
//  SportScore
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// LeagueContext/Application/Interfaces/LeagueRepository.swift
protocol LeagueRepository {
    func getLeagues(country: String, sport: String) async throws -> [League]
    func lookupLeague(by League_ID: String) async throws -> [League]
    func lookupLeagueTable(league_ID: String, season: String) async throws -> [LeagueTable]
}

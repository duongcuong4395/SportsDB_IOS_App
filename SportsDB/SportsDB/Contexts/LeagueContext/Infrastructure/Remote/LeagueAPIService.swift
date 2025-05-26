//
//  LeagueAPIService.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// LeagueContext/Infrastructure/Remote/LeagueAPIService.swift
final class LeagueAPIService: LeagueRepository {

    func getLeagues(country: String) async throws -> [League] {
        let urlString = "https://yourdomain.com/api/v1/json/3/search_all_leagues.php?c=\(country)"
        return try await fetchLeagues(from: urlString)
    }

    func getLeagues(country: String, sport: String) async throws -> [League] {
        let urlString = "https://yourdomain.com/api/v1/json/3/search_all_leagues.php?c=\(country)&s=\(sport)"
        return try await fetchLeagues(from: urlString)
    }

    private func fetchLeagues(from urlString: String) async throws -> [League] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(LeaguesInACountryAPIResponse.self, from: data)
        return response.Leagues.map { $0.toDomain() }
    }
}


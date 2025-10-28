//
//  LeagueAPIService.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation
import Networking

final class LeagueAPIService: LeagueRepository, APIExecution {

    func getLeagues(country: String, sport: String) async throws -> [League] {
        let response: ListLeaguesAPIResponse = try await sendRequest(for: LeagueEndpoint<ListLeaguesAPIResponse>.GetLeagues(country: country, sport: sport))
        
        return response.leagues.map { $0.toDomain() }
    }
    
    func lookupLeague(by League_ID: String) async throws -> [League] {
        let response: LookupLeagueAPIResponse = try await sendRequest(for: LeagueEndpoint<LookupLeagueAPIResponse>.LookupLeague(league_ID: League_ID))
        
        return response.leagues.map { $0.toDomain() }
    }
    
    func lookupLeagueTable(league_ID: String, season: String) async throws -> [LeagueTable] {
        let response: LookupLeagueTableAPIResponse = try await sendRequest(for: LeagueEndpoint<LookupLeagueTableAPIResponse>.LookupLeagueTable(league_ID: league_ID, season: season))
        
        return response.leagueTable.map { $0.toDomain() }
    }
}


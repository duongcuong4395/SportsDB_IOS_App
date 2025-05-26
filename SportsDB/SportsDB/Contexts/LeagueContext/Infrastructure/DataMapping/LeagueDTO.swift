//
//  LeagueDTO.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// LeagueContext/Infrastructure/DataMapping/LeagueDTO.swift
struct LeaguesInACountryAPIResponse: Codable {
    let Leagues: [LeagueDTO]
}

struct LeagueDTO: Codable {
    let idLeague: String
    let strSport: String
    let strLeague: String
    let strCountry: String
    let strBadge: String?

    func toDomain() -> League {
        League(
            id: idLeague,
            name: strLeague,
            sport: strSport,
            country: strCountry,
            badgeURL: URL(string: strBadge ?? "")
        )
    }
}


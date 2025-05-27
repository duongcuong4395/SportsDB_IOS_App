//
//  LookupLeagueAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

struct LookupLeagueAPIResponse: Codable {
    let leagues: [LeagueDTO]
    
    enum CodingKeys: String, CodingKey {
        case leagues = "leagues"
    }
}

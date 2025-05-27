//
//  ListLeaguesAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

struct ListLeaguesAPIResponse: Codable {
    var leagues: [LeagueDTO]
    
    enum CodingKeys: String, CodingKey {
        case leagues = "countries"
    }
}

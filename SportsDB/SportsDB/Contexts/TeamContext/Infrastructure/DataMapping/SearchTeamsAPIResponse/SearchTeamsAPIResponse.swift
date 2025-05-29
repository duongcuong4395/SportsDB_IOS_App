//
//  SearchTeamsAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct SearchTeamsAPIResponse: Codable {
    var teams: [TeamDTO]? = []
    
    enum CodingKeys: String, CodingKey {
        case teams = "teams"
    }
}

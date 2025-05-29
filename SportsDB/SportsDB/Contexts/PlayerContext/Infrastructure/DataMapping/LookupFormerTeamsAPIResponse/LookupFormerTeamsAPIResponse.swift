//
//  LookupPlayerFormerTeamsAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct LookupFormerTeamsAPIResponse: Codable {
    var formerTeams: [FormerTeamDTO]?
    
    enum CodingKeys: String, CodingKey {
        case formerTeams = "formerteams"
    }
}

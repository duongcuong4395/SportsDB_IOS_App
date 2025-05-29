//
//  GetListTeamsAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct GetListTeamsAPIResponse: Codable {
    var teams: [TeamDTO]? = []
    
    enum CodingKeys: String, CodingKey {
        case teams = "teams"
    }
}

//
//  LookupAllPlayersAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 2/6/25.
//

struct LookupAllPlayersAPIResponse: Codable {
    var players: [PlayerDTO]?
    
    enum CodingKeys: String, CodingKey {
        case players = "player"
    }
}

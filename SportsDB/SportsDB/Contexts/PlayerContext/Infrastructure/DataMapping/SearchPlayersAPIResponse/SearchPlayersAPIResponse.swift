//
//  SearchPlayersAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct SearchPlayersAPIResponse: Codable {
    var players: [PlayerDTO]?
    
    enum CodingKeys: String, CodingKey {
        case players = "player"
    }
}

//
//  Contract.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct Contract: Codable {
    var id, idPlayer, idTeam, sport: String
    var player, team: String
    var badge: String
    var yearStart, yearEnd, wage: String
}

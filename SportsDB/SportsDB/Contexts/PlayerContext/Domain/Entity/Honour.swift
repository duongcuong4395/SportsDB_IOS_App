//
//  HonourDTO.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct Honour: Equatable {
    var id, idPlayer, idTeam, idLeague: String
    var idHonour, sport, player, team: String
    var teamBadge: String
    var honour: String
    var honourLogo, honourTrophy: String
    var season: String
}

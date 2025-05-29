//
//  HonourDTO.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//



// MARK: - Honour
struct HonourDTO: Codable {
    var id, idPlayer, idTeam, idLeague: String
    var idHonour, sport, player, team: String
    var teamBadge: String
    var honour: String
    var honourLogo, honourTrophy: String
    var season: String
    
    enum CodingKeys: String, CodingKey {
        case id, idPlayer, idTeam, idLeague
        case idHonour, sport = "strSport", player = "strPlayer", team = "strTeam"
        case teamBadge = "strTeamBadge"
        case honour = "strHonour"
        case honourLogo = "strHonourLogo", honourTrophy = "strHonourTrophy"
        case season = "strSeason"
    }
    
    func toDomain() -> Honour {
        Honour(id: id, idPlayer: idPlayer, idTeam: idTeam, idLeague: idLeague, idHonour: idHonour, sport: sport, player: player, team: team, teamBadge: teamBadge, honour: honour, honourLogo: honourLogo, honourTrophy: honourTrophy, season: season)
    }
}

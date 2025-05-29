//
//  FormerTeamsDTO.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

// MARK: - Formerteam
struct FormerTeamDTO: Codable {
    var id, idPlayer, idFormerTeam, sport: String
    var player, formerTeam, moveType: String
    var badge: String
    var joined, departed: String
    
    enum CodingKeys: String, CodingKey {
        case id, idPlayer, idFormerTeam, sport = "strSport"
        case player = "strPlayer", formerTeam = "strFormerTeam", moveType = "strMoveType"
        case badge = "strBadge"
        case joined = "strJoined", departed = "strDeparted"
    }
    
    func toDomain() -> FormerTeam {
        FormerTeam(id: id, idPlayer: idPlayer, idFormerTeam: idFormerTeam, sport: sport, player: player, formerTeam: formerTeam, moveType: moveType, badge: badge, joined: joined, departed: departed)
    }
}

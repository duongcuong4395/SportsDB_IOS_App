//
//  ContractDTO.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//


// MARK: - Contract
struct ContractDTO: Codable {
    var id, idPlayer, idTeam, sport: String
    var player, team: String
    var badge: String
    var yearStart, yearEnd, wage: String
    
    enum CodingKeys: String, CodingKey {
        case id, idPlayer, idTeam, sport = "strSport"
        case player = "strPlayer", team = "strTeam"
        case badge = "strBadge"
        case yearStart = "strYearStart", yearEnd = "strYearEnd", wage = "strWage"
    }
    
    func toDomain() -> Contract {
        Contract(id: id, idPlayer: idPlayer, idTeam: idTeam, sport: sport, player: player, team: team, badge: badge, yearStart: yearStart, yearEnd: yearEnd, wage: wage)
    }
}

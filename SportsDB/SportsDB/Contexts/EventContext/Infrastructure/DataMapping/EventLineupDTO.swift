//
//  EventLineupDTO.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

// MARK: - Lineup
struct EventLineupDTO: Codable {
    var idLineup, idEvent, position, home: String
    var substitute, squadNumber, idPlayer, player: String
    var idTeam, team: String
    var cutout: String
    var thumb: String
    var render: String
    
    enum CodingKeys: String, CodingKey {
        case idLineup, idEvent, position = "strPosition", home = "strHome"
        case substitute = "strSubstitute", squadNumber = "intSquadNumber", idPlayer, player = "strPlayer"
        case idTeam, team = "strTeam"
        case cutout = "strCutout"
        case thumb = "strThumb"
        case render = "strRender"
    }
    
    func toDomain() -> EventLineup {
        EventLineup(idLineup: idLineup, idEvent: idEvent, position: position, home: home, substitute: substitute, squadNumber: squadNumber, idPlayer: idPlayer, player: player, idTeam: idTeam, team: team, cutout: cutout, thumb: thumb, render: render)
    }
}

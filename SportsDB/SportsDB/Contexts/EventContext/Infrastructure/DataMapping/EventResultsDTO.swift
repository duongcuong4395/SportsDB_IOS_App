//
//  EventResultsDTO.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

// MARK: - Result
struct EventResultDTO: Codable {
    var idResult, idPlayer, player, idTeam: String
    var idEvent, event: String
    var result: String?
    var position, points, detail, dateEvent: String
    var season, country, sport: String
    
    enum CodingKeys: String, CodingKey {
        case idResult, idPlayer, player = "strPlayer", idTeam
        case idEvent, event = "strEvent"
        case result = "strResult"
        case position = "intPosition", points = "intPoints", detail = "strDetail", dateEvent
        case season = "strSeason", country = "strCountry", sport = "strSport"
    }
    
    func toDomain() -> EventResult {
        EventResult(idResult: idResult, idPlayer: idPlayer, player: player, idTeam: idTeam, idEvent: idEvent, event: event, position: position, points: points, detail: detail, dateEvent: dateEvent, season: season, country: country, sport: sport)
    }
}

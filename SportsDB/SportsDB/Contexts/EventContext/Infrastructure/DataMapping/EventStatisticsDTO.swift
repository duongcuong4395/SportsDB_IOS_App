//
//  EventStatisticsDTO.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//


// MARK: - Eventstat
struct EventStatisticsDTO: Codable {
    var idStatistic, idEvent, idAPIFootball, event: String
    var stat, home, away: String

    enum CodingKeys: String, CodingKey {
        case idStatistic, idEvent
        case idAPIFootball = "idApiFootball"
        case event = "strEvent", stat = "strStat", home = "intHome", away = "intAway"
    }
    
    func toDomain() -> EventStatistics {
        EventStatistics(idStatistic: idStatistic, idEvent: idEvent, idAPIFootball: idAPIFootball, event: event, stat: stat, home: home, away: away)
    }
}

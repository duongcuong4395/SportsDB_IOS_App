//
//  EventTimelineDTO.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

// MARK: - Timeline
struct EventTimelineDTO: Codable {
    var idTimeline, idEvent, timeline, timelineDetail: String
    var home, event, idAPIfootball, idPlayer: String
    var player: String
    var country, idAssist: String?
    var assist, time, idTeam, team: String
    var comment, dateEvent, season: String
    
    enum CodingKeys: String, CodingKey {
        case idTimeline, idEvent, timeline = "strTimeline", timelineDetail = "strTimelineDetail"
        case home = "strHome", event = "strEvent", idAPIfootball, idPlayer
        case player = "strPlayer"
        case country = "strCountry", idAssist
        case assist = "strAssist", time = "intTime", idTeam, team = "strTeam"
        case comment = "strComment", dateEvent, season = "strSeason"
    }
    
    func toDomain() -> EventTimeline {
        EventTimeline(idTimeline: idTimeline, idEvent: idEvent, timeline: timeline, timelineDetail: timelineDetail, home: home, event: event, idAPIfootball: idAPIfootball, idPlayer: idPlayer, player: player, country: country, idAssist: idAssist, assist: assist, time: time, idTeam: idTeam, team: team, comment: comment, dateEvent: dateEvent, season: season)
    }
}

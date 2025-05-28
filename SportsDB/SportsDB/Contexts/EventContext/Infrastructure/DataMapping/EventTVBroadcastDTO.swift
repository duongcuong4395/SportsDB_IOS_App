//
//  EventTVBroadcastDTO.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//



// MARK: - Tvevent
struct EventTVBroadcastDTO: Codable {
    var id, idEvent: String
    var division: String?
    var sport, event: String
    var eventThumb, eventPoster, eventBanner, eventSquare: String?
    var idChannel, country: String
    var eventCountry: String?
    var logo: String
    var channel, season, time, dateEvent: String
    var timeStamp: String?
    
    enum CodingKeys: String, CodingKey {
        case id, idEvent
        case division = "intDivision"
        case sport = "strSport", event = "strEvent"
        case eventThumb = "strEventThumb", eventPoster = "strEventPoster"
        case eventBanner = "strEventBanner", eventSquare = "strEventSquare"
        case idChannel, country = "strCountry"
        case eventCountry = "strEventCountry"
        case logo = "strLogo"
        case channel = "strChannel", season = "strSeason", time = "strTime", dateEvent
        case timeStamp = "strTimeStamp"
    }
    
    func toDomain() -> EventTVBroadcast {
        EventTVBroadcast(id: id, idEvent: idEvent, sport: sport, event: event, idChannel: idChannel, country: country, logo: logo, channel: channel, season: season, time: time, dateEvent: dateEvent)
    }
    
}

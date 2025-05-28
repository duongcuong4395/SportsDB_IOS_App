//
//  EventTVBroadcast.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//



// MARK: - Tvevent
struct EventTVBroadcast: Equatable {
    var id, idEvent: String
    var division: String?
    var sport, event: String
    var eventThumb, eventPoster, eventBanner, eventSquare: String?
    var idChannel, country: String
    var eventCountry: String?
    var logo: String
    var channel, season, time, dateEvent: String
    var timeStamp: String?
}

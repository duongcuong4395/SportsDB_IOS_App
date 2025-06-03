//
//  Event.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

struct Event: Equatable, Identifiable {
    var id = UUID()
    var idEvent, idAPIfootball, eventName, eventAlternate: String?
    var filename, sportName, idLeague, leagueName: String?
    var leagueBadge: String?
    var season, descriptionEN, homeTeam, awayTeam: String?
    var homeScore, round, awayScore: String?
    var spectators: String?
    var official, timestamp, dateEvent, dateEventLocal: String?
    var time, timeLocal, group, idHomeTeam: String?
    var homeTeamBadge: String?
    var idAwayTeam: String?
    var awayTeamBadge: String?
    var score, scoreVotes: String?
    var result, idVenue, venue, country: String?
    var city: String?
    var poster, square: String?
    var fanart: String?
    var thumb, banner: String?
    var map: String?
    var tweet1, tweet2, tweet3: String?
    var video: String?
    var status, postponed, locked: String?
}

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
    
    var like: Bool = false
    var hasNotification: Bool = false
}


import SwiftData

extension Event{
    func toEventSwiftData() -> EventSwiftData {
        EventSwiftData(
            idEvent: idEvent
            , idAPIfootball: idAPIfootball
            , eventName: eventName
            , eventAlternate: eventAlternate
            , filename: filename
            , sportName: sportName
            , idLeague: idLeague
            , leagueName: leagueName
            , leagueBadge: leagueBadge
            , season: season
            , descriptionEN: descriptionEN
            , homeTeam: homeTeam
            , awayTeam: awayTeam
            , homeScore: homeScore
            , round: round
            , awayScore: awayScore
            , spectators: spectators
            , official: official
            , timestamp: timestamp
            , dateEvent: dateEvent
            , dateEventLocal: dateEventLocal
            , time: time
            , timeLocal: timeLocal
            , group: group
            , idHomeTeam: idHomeTeam
            , homeTeamBadge: homeTeamBadge
            , idAwayTeam: idAwayTeam
            , awayTeamBadge: awayTeamBadge
            , score: score
            , scoreVotes: scoreVotes
            , result: result
            , idVenue: idVenue
            , venue: venue
            , country: country
            , city: city
            , poster: poster
            , square: square
            , fanart: fanart
            , thumb: thumb
            , banner: banner
            , map: map, tweet1: tweet1, tweet2: tweet2, tweet3: tweet3, video: video, status: status
            , postponed: postponed, locked: locked, like: like, hasNotification: hasNotification)
    }
}


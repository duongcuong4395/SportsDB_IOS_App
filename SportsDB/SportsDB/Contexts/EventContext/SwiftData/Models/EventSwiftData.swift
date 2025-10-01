//
//  EventSwiftData.swift
//  SportsDB
//
//  Created by Macbook on 10/8/25.
//

import SwiftUI
import CoreData
import SwiftData

enum NotificationStatus: String{
    case idle = "idle"
    case creeated = "creeated"
    case hasRead = "hasRead"
}

@Model class EventSwiftData  {
    //var id: UUID { UUID() }
    var idEvent: String?
    var idAPIfootball: String?
    var eventName: String?
    var eventAlternate: String?
    var filename: String?
    var sportName: String?
    var idLeague: String?
    var leagueName: String?
    var leagueBadge: String?
    var season: String?
    var descriptionEN: String?
    var homeTeam: String?
    var awayTeam: String?
    var homeScore: String?
    var round: String?
    var awayScore: String?
    var spectators: String?
    var official: String?
    var timestamp: String?
    var dateEvent: String?
    var dateEventLocal: String?
    var time: String?
    var timeLocal: String?
    var group: String?
    var idHomeTeam: String?
    var homeTeamBadge: String?
    var idAwayTeam: String?
    var awayTeamBadge: String?
    var score: String?
    var scoreVotes: String?
    var result: String?
    var idVenue: String?
    var venue: String?
    var country: String?
    var city: String?
    var poster: String?
    var square: String?
    var fanart: String?
    var thumb: String?
    var banner: String?
    var map: String?
    var tweet1: String?
    var tweet2: String?
    var tweet3: String?
    var video: String?
    var status: String?
    var postponed: String?
    var locked: String?
    
    var like: Bool
    var notificationStatus: String //= NotificationStatus.idle.rawValue
    
    init(idEvent: String?, idAPIfootball: String?, eventName: String?, eventAlternate: String?, filename: String?, sportName: String?, idLeague: String?, leagueName: String?, leagueBadge: String?, season: String?, descriptionEN: String?, homeTeam: String?, awayTeam: String?, homeScore: String?, round: String?, awayScore: String?, spectators: String?, official: String?, timestamp: String?, dateEvent: String?, dateEventLocal: String?, time: String?, timeLocal: String?, group: String?, idHomeTeam: String?, homeTeamBadge: String?, idAwayTeam: String?, awayTeamBadge: String?, score: String?, scoreVotes: String?, result: String?, idVenue: String?, venue: String?, country: String?, city: String?, poster: String?, square: String?, fanart: String?, thumb: String?, banner: String?, map: String?, tweet1: String?, tweet2: String?, tweet3: String?, video: String?, status: String?, postponed: String?, locked: String?
         , like: Bool
         , notificationStatus: String) {
        self.idEvent = idEvent
        self.idAPIfootball = idAPIfootball
        self.eventName = eventName
        self.eventAlternate = eventAlternate
        self.filename = filename
        self.sportName = sportName
        self.idLeague = idLeague
        self.leagueName = leagueName
        self.leagueBadge = leagueBadge
        self.season = season
        self.descriptionEN = descriptionEN
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.round = round
        self.awayScore = awayScore
        self.spectators = spectators
        self.official = official
        self.timestamp = timestamp
        self.dateEvent = dateEvent
        self.dateEventLocal = dateEventLocal
        self.time = time
        self.timeLocal = timeLocal
        self.group = group
        self.idHomeTeam = idHomeTeam
        self.homeTeamBadge = homeTeamBadge
        self.idAwayTeam = idAwayTeam
        self.awayTeamBadge = awayTeamBadge
        self.score = score
        self.scoreVotes = scoreVotes
        self.result = result
        self.idVenue = idVenue
        self.venue = venue
        self.country = country
        self.city = city
        self.poster = poster
        self.square = square
        self.fanart = fanart
        self.thumb = thumb
        self.banner = banner
        self.map = map
        self.tweet1 = tweet1
        self.tweet2 = tweet2
        self.tweet3 = tweet3
        self.video = video
        self.status = status
        self.postponed = postponed
        self.locked = locked
        self.like = like
        self.notificationStatus = notificationStatus
    }
    
    func getDateTime() -> String {
        AppUtility.formatDate(from: timestamp ?? "", to: "dd/MM/yyyy HH:mm") ?? ""
    }
    
    func toEvent() -> Event {
        var newEvent = Event()
        newEvent.idEvent = idEvent
        newEvent.idAPIfootball = idAPIfootball
        newEvent.eventName = eventName
        newEvent.eventAlternate = eventAlternate
        newEvent.filename = filename
        newEvent.sportName = sportName
        newEvent.idLeague = idLeague
        newEvent.leagueName = leagueName
        newEvent.leagueBadge = leagueBadge
        newEvent.season = season
        newEvent.descriptionEN = descriptionEN
        newEvent.homeTeam = homeTeam
        newEvent.awayTeam = awayTeam
        newEvent.homeScore = homeScore
        newEvent.round = round
        newEvent.awayScore = awayScore
        newEvent.spectators = spectators
        newEvent.official = official
        newEvent.timestamp = timestamp
        newEvent.dateEvent = dateEvent
        newEvent.dateEventLocal = dateEventLocal
        newEvent.time = time
        newEvent.timeLocal = timeLocal
        newEvent.group = group
        newEvent.idHomeTeam = idHomeTeam
        newEvent.homeTeamBadge = homeTeamBadge
        newEvent.idAwayTeam = idAwayTeam
        newEvent.awayTeamBadge = awayTeamBadge
        newEvent.score = score
        newEvent.scoreVotes = scoreVotes
        newEvent.result = result
        newEvent.idVenue = idVenue
        newEvent.venue = venue
        newEvent.country = country
        newEvent.city = city
        newEvent.poster = poster
        newEvent.square = square
        newEvent.fanart = fanart
        newEvent.thumb = thumb
        newEvent.banner = banner
        newEvent.map = map
        newEvent.tweet1 = tweet1
        newEvent.tweet2 = tweet2
        newEvent.tweet3 = tweet3
        newEvent.video = video
        newEvent.status = status
        newEvent.postponed = postponed
        newEvent.locked = locked
        newEvent.like = like
        //newEvent.notificationStatus = notificationStatus
        return newEvent
    }
}

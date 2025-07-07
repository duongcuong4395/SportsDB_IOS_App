//
//  EventDTO.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

// MARK: - Event
struct EventDTO: Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case idEvent, idAPIfootball, eventName = "strEvent", eventAlternate = "strEventAlternate"
        case filename = "strFilename", sportName = "strSport", idLeague, leagueName = "strLeague"
        case leagueBadge = "strLeagueBadge"
        case season = "strSeason", descriptionEN = "strDescriptionEN", homeTeam = "strHomeTeam", awayTeam = "strAwayTeam"
        case homeScore = "intHomeScore", round = "intRound", awayScore = "intAwayScore"
        case spectators = "intSpectators"
        case official = "strOfficial", timestamp = "strTimestamp", dateEvent = "dateEvent", dateEventLocal = "dateEventLocal"
        case time = "strTime", timeLocal = "strTimeLocal", group = "strGroup", idHomeTeam
        case homeTeamBadge = "strHomeTeamBadge"
        case idAwayTeam
        case awayTeamBadge = "strAwayTeamBadge"
        case score = "intScore", scoreVotes = "intScoreVotes"
        case result = "strResult", idVenue, venue = "strVenue", country = "strCountry"
        case city = "strCity"
        case poster = "strPoster", square = "strSquare"
        case fanart = "strFanart"
        case thumb = "strThumb", banner = "strBanner"
        case map = "strMap"
        case tweet1 = "strTweet1", tweet2 = "strTweet2", tweet3 = "strTweet3"
        case video = "strVideo"
        case status = "strStatus", postponed = "strPostponed", locked = "strLocked"
    }
    
    func toDomain() -> Event {
        Event(idEvent: idEvent,
              idAPIfootball: idAPIfootball,
              eventName: eventName,
              eventAlternate: eventAlternate,
              filename: filename,
              sportName: sportName,
              idLeague: idLeague,
              leagueName: leagueName,
              leagueBadge: leagueBadge,
              season: season,
              descriptionEN: descriptionEN,
              homeTeam: homeTeam,
              awayTeam: awayTeam,
              homeScore: homeScore,
              round: round,
              awayScore: awayScore,
              spectators: spectators,
              official: official,
              timestamp: timestamp,
              dateEvent: dateEvent,
              dateEventLocal: dateEventLocal,
              time: time,
              timeLocal: timeLocal,
              group: group,
              idHomeTeam: idHomeTeam,
              homeTeamBadge: homeTeamBadge,
              idAwayTeam: idAwayTeam,
              awayTeamBadge: awayTeamBadge,
              score: score,
              scoreVotes: scoreVotes,
              result: result,
              idVenue: idVenue,
              venue: venue,
              country: country,
              city: city,
              poster: poster,
              square: square,
              fanart: fanart,
              thumb: thumb,
              banner: banner,
              map: map,
              tweet1: tweet1,
              tweet2: tweet2,
              tweet3: tweet3,
              video: video,
              status: status,
              postponed: postponed,
              locked: locked)
    }
}


let eventExampleJson = """
{
            "idEvent": "2070119",
            "idAPIfootball": "1208304",
            "strEvent": "Arsenal vs Chelsea",
            "strEventAlternate": "Chelsea @ Arsenal",
            "strFilename": "English Premier League 2025-03-16 Arsenal vs Chelsea",
            "strSport": "Soccer",
            "idLeague": "4328",
            "strLeague": "English Premier League",
            "strLeagueBadge": "https://www.thesportsdb.com/images/media/league/badge/gasy9d1737743125.png",
            "strSeason": "2024-2025",
            "strDescriptionEN": "",
            "strHomeTeam": "Arsenal",
            "strAwayTeam": "Chelsea",
            "intHomeScore": "1",
            "intRound": "29",
            "intAwayScore": "0",
            "intSpectators": null,
            "strOfficial": "",
            "strTimestamp": "2025-03-16T13:30:00",
            "dateEvent": "2025-03-16",
            "dateEventLocal": "2025-03-16",
            "strTime": "13:30:00",
            "strTimeLocal": "13:30:00",
            "strGroup": "",
            "idHomeTeam": "133604",
            "strHomeTeamBadge": "https://r2.thesportsdb.com/images/media/team/badge/uyhbfe1612467038.png",
            "idAwayTeam": "133610",
            "strAwayTeamBadge": "https://r2.thesportsdb.com/images/media/team/badge/yvwvtu1448813215.png",
            "intScore": null,
            "intScoreVotes": null,
            "strResult": "",
            "idVenue": "15528",
            "strVenue": "Emirates Stadium",
            "strCountry": "England",
            "strCity": "",
            "strPoster": "https://r2.thesportsdb.com/images/media/event/poster/7vasnz1689062738.jpg",
            "strSquare": "https://r2.thesportsdb.com/images/media/event/square/m57qk51689062881.jpg",
            "strFanart": null,
            "strThumb": "https://r2.thesportsdb.com/images/media/event/thumb/wy5re41689062588.jpg",
            "strBanner": "https://r2.thesportsdb.com/images/media/event/banner/tiaudc1689063002.jpg",
            "strMap": null,
            "strTweet1": "",
            "strTweet2": "",
            "strTweet3": "",
            "strVideo": "https://www.youtube.com/watch?v=_D3B-_8Na40",
            "strStatus": "Match Finished",
            "strPostponed": "no",
            "strLocked": "unlocked"
        }
"""




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


func getEventExample() -> Event {
    if let jsonEventDTOData = eventExampleJson.data(using: .utf8) {
        do {
            let decoder = JSONDecoder()
            let eventDTO = try decoder.decode(EventDTO.self, from: jsonEventDTOData)
            let domainModel = eventDTO.toDomain()
            return domainModel
        } catch {
            print("❌ JSON decode failed: \(error)")
        }
    }
    
    return Event()
}

let eventExampleJson = """
{
            "idEvent": "2267091",
            "idAPIfootball": "1378987",
            "strEvent": "Newcastle United vs Liverpool",
            "strEventAlternate": "Liverpool @ Newcastle United",
            "strFilename": "English Premier League 2025-08-25 Newcastle United vs Liverpool",
            "strSport": "Soccer",
            "idLeague": "4328",
            "strLeague": "English Premier League",
            "strLeagueBadge": "https://r2.thesportsdb.com/images/media/league/badge/gasy9d1737743125.png",
            "strSeason": "2025-2026",
            "strDescriptionEN": "",
            "strHomeTeam": "Newcastle United",
            "strAwayTeam": "Liverpool",
            "intHomeScore": null,
            "intRound": "2",
            "intAwayScore": null,
            "intSpectators": null,
            "strOfficial": "",
            "strTimestamp": "2025-08-25T19:00:00",
            "dateEvent": "2025-08-25",
            "dateEventLocal": "2025-08-25",
            "strTime": "19:00:00",
            "strTimeLocal": "20:00:00",
            "strGroup": "",
            "idHomeTeam": "134777",
            "strHomeTeamBadge": "https://r2.thesportsdb.com/images/media/team/badge/lhwuiz1621593302.png",
            "idAwayTeam": "133602",
            "strAwayTeamBadge": "https://r2.thesportsdb.com/images/media/team/badge/kfaher1737969724.png",
            "intScore": null,
            "intScoreVotes": null,
            "strResult": "",
            "idVenue": "16294",
            "strVenue": "St James Park",
            "strCountry": "England",
            "strCity": "",
            "strPoster": "https://r2.thesportsdb.com/images/media/event/poster/5zi6fm1750323194.jpg",
            "strSquare": "https://r2.thesportsdb.com/images/media/event/square/95kpaw1750325399.jpg",
            "strFanart": null,
            "strThumb": "https://r2.thesportsdb.com/images/media/event/thumb/adm6sl1750320152.jpg",
            "strBanner": "https://r2.thesportsdb.com/images/media/event/banner/vr2jt71750328284.jpg",
            "strMap": null,
            "strTweet1": "",
            "strTweet2": "",
            "strTweet3": "",
            "strVideo": "",
            "strStatus": "Not Started",
            "strPostponed": "no",
            "strLocked": "unlocked"
        }
"""




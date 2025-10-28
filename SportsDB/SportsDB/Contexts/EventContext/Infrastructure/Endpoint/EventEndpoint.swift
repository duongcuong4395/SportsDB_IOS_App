//
//  EventEndpoint.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Alamofire
import Networking
import Foundation

enum NextAndPrevious: String {
    case Next = "next"
    case Previous = "previous"
}

enum EventEndpoint<T: Decodable> {
    
    case SearchEvents(eventName: String, season: String)
    case LookupEvent(eventID: String)
    case LookupEventResults(eventID: String)
    
    case LookupEventLineup(eventID: String)
    
    case LookupEventTimeline(eventID: String)
    
    case LookupEventStatistics(eventID: String)
    
    case LookupEventTVBroadcasts(eventID: String)
    
    case LookupListEvents(leagueID: String, round: String, season: String)
    //https://www.thesportsdb.com/api/v1/json/3/eventsround.php?id=4569&r=1&s=2025
    
    case LookupEventsInSpecific(leagueID: String, season: String)
    
    //https://www.thesportsdb.com/api/v1/json/3/eventspastleague.php?id=4328
    case LookupEventsPastLeague(leagueID: String)
        
    case GetEvents(of: String, by: NextAndPrevious)
}


extension EventEndpoint: HttpRouter {
    typealias responseDataType = T
    
    var baseURL: String {
        AppUtility.SportBaseURL
    }
    
    var path: String {
        switch self {
        case .SearchEvents(eventName: _, season: _):
            return "api/v1/json/3/searchevents.php"
        case .LookupEvent(eventID: _):
            return "api/v1/json/3/lookupevent.php"
        case .LookupEventResults(eventID: _):
            return "api/v1/json/3/eventresults.php"
        case .LookupEventLineup(eventID: _):
            return "api/v1/json/3/lookuplineup.php"
        case .LookupEventTimeline(eventID: _):
            return "api/v1/json/3/lookuptimeline.php"
        case .LookupEventStatistics(eventID: _):
            return "api/v1/json/3/lookupeventstats.php"
        case .LookupEventTVBroadcasts(eventID: _):
            return "api/v1/json/3/lookuptv.php"
        case .LookupListEvents(leagueID: _, round: _, season: _):
            return "api/v1/json/3/eventsround.php"
        case .LookupEventsInSpecific(leagueID: _, season: _):
            return "api/v1/json/3/eventsseason.php"
        case .LookupEventsPastLeague(leagueID: _):
            return "api/v1/json/123/eventspastleague.php"
            
            /*
        case .GetUpcomingEventsForATeam(teamID: let teamID):
            return "api/v1/json/123/eventsnext.php"
        case .GetRecentEventsForATeam(teamID: let teamID):
            return "api/v1/json/3/eventslast.php"
            */
        case .GetEvents(of: _, by: let nextAndPrevious):
            switch nextAndPrevious {
            case .Next:
                return "api/v1/json/123/eventsnext.php"
            case .Previous:
                return "api/v1/json/3/eventslast.php"
            }
        }
    }
    
    var method: Alamofire.HTTPMethod {
        .get
    }
    
    var headers: Alamofire.HTTPHeaders? {
        nil
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .SearchEvents(eventName: let eventName, season: let season):
            if season.isEmpty {
                return ["e": eventName]
            } else {
                return ["e": eventName, "s": season]
            }
        case .LookupEvent(eventID: let eventID):
            return ["id": eventID]
        case .LookupEventResults(eventID: let eventID):
            return ["id": eventID]
        case .LookupEventLineup(eventID: let eventID):
            return ["id": eventID]
        case .LookupEventTimeline(eventID: let eventID):
            return ["id": eventID]
        case .LookupEventStatistics(eventID: let eventID):
            return ["id": eventID]
        case .LookupEventTVBroadcasts(eventID: let eventID):
            return ["id": eventID]
        
        case .LookupListEvents(leagueID: let leagueID, round: let round, season: let season):
            return ["id": leagueID, "r": round, "s": season]
        case .LookupEventsInSpecific(leagueID: let leagueID, season: let season):
            return ["id": leagueID, "s": season]
        case .LookupEventsPastLeague(leagueID: let leagueID):
            return ["id": leagueID]
            /*
        case .GetUpcomingEventsForATeam(teamID: let teamID):
            return ["id": teamID]
        case .GetRecentEventsForATeam(teamID: let teamID):
            return ["id": teamID]
             */
        case .GetEvents(of: let teamID, by: _):
            return ["id": teamID]
        }
    }
    
    var body: Data? {
        nil
    }
    
    
}

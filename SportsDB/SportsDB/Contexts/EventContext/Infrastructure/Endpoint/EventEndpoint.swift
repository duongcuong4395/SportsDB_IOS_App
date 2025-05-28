//
//  EventEndpoint.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation
import Alamofire

enum EventEndpoint<T: Decodable> {
    
    case SearchEvents(eventName: String, season: String)
    case LookupEvent(eventID: String)
    case LookupEventResults(eventID: String)
    
    case LookupEventLineup(eventID: String)
    
    case LookupEventTimeline(eventID: String)
    
    case LookupEventStatistics(eventID: String)
    
    case LookupEventTVBroadcasts(eventID: String)
    
    case LookupEventVenue(eventID: String)
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
        case .LookupEventVenue(eventID: _):
            return "api/v1/json/3/lookupvenue.php"
        }
    }
    
    var menthod: Alamofire.HTTPMethod {
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
        case .LookupEventVenue(eventID: let eventID):
            return ["id": eventID]
        }
    }
    
    var body: Data? {
        nil
    }
    
    
}

//
//  VenueEndpoint.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//

enum VenueEndpoint<T: Decodable> {
    case LookupVenue(eventID: String)
    case SearchVenues(venueName: String)
}

import Foundation
import Alamofire

extension VenueEndpoint: HttpRouter {
    typealias responseDataType = T
    
    var baseURL: String {
        AppUtility.SportBaseURL
    }
    
    var path: String {
        switch self {
        case .LookupVenue(eventID: _):
            return "api/v1/json/3/lookupvenue.php"
        case .SearchVenues(venueName: _):
            return "api/v1/json/3/searchvenues.php"
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
        case .LookupVenue(eventID: let eventID):
            return ["id": eventID]
        case .SearchVenues(venueName: let venueName):
            return ["v": venueName]
            
        }
    }
    
    var body: Data? {
        nil
    }
    
    
}

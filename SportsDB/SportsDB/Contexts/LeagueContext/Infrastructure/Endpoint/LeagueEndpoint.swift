//
//  LeagueEndpoint.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation
import Alamofire

enum LeagueEndpoint<T: Decodable> {
    case GetLeagues(country: String, sport: String)
    
    case LookupLeague(league_ID: String)
    
    case LookupLeagueTable(league_ID: String, season: String)
}


extension LeagueEndpoint: HttpRouter {
    typealias responseDataType = T
    
    var path: String {
        switch self {
        case .GetLeagues(country: _, sport: _):
            return "api/v1/json/3/search_all_leagues.php"
        case .LookupLeague(league_ID: _):
            return "api/v1/json/3/lookupleague.php"
        case .LookupLeagueTable(league_ID: _, season: _):
            return "api/v1/json/3/lookuptable.php"
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
        case .GetLeagues(country: let countryName, sport: let sportType):
            if sportType.isEmpty {
                return ["c": countryName]
            } else {
                return ["c": countryName, "s": sportType]
            }
        case .LookupLeague(league_ID: let league_ID):
            return ["id": league_ID]
        case .LookupLeagueTable(league_ID: let league_ID, season: let season):
            return ["l": league_ID, "s": season]
        }
    
    }
    
    var body: Data? {
        nil
    }
    
    var baseURL: String {
        AppUtility.SportBaseURL
    }
}

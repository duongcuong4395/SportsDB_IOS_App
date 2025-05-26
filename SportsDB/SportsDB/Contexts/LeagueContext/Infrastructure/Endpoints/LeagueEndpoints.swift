//
//  LeagueEndpoint.swift
//  SportsDB
//
//  Created by Macbook on 26/5/25.
//

import Foundation
import Alamofire

enum LeagueEndpoint<T: Decodable> {
    // https://www.thesportsdb.com/api/v1/json/3/search_all_leagues.php?c=England
    case GetLeagues(from: String, by: String) // SportType
}


extension LeagueEndpoint: HttpRouter {
    typealias responseDataType = T
    
    var path: String {
        switch self {
        case .GetLeagues(from: _, by: _):
            return "api/v1/json/3/search_all_leagues.php"
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
        case .GetLeagues(from: let countryName, by: let sportType):
            if sportType.isEmpty {
                return ["c": countryName]
            } else {
                return ["c": countryName, "s": sportType]
            }
        }
    
    }
    
    var body: Data? {
        nil
    }
    
    var baseURL: String {
        AppUtility.SportBaseURL
    }
}

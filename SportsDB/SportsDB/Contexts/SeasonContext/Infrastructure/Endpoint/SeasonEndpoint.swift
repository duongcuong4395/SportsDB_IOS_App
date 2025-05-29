//
//  SeasonEndpoint.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import Foundation
import Alamofire

enum SeasonEndpoint<T: Decodable> {
    case GetListSeasons(leagueID: String)
}

extension SeasonEndpoint: HttpRouter {
    typealias responseDataType = T
    
    var baseURL: String {
        AppUtility.SportBaseURL
    }
    
    var path: String {
        switch self {
        case .GetListSeasons(leagueID: _):
            return "api/v1/json/3/search_all_seasons.php"
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
        case .GetListSeasons(leagueID: let leagueID):
            return ["id": leagueID]
        }
    }
    
    var body: Data? {
        nil
    }
    
    
}

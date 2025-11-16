//
//  TeamEndpoint.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

enum TeamEndpoint<T: Decodable> {
    case GetListTeams(leagueName: String, sportName: String, countryName: String)
    case SearchTeams(teamName: String)
    case LookupTeam(teamID: String)
    
    case LookupEquipment(teamID: String)
}

import Foundation
import Alamofire
import Networking

extension TeamEndpoint: HttpRouter {
    typealias ResponseType = T
    
    //typealias responseDataType = T
    
    var baseURL: String {
        AppUtility.SportBaseURL
    }
    
    var path: String {
        switch self {
        case .GetListTeams(leagueName: _, sportName: _, countryName: _):
            return "api/v1/json/3/search_all_teams.php"
        case .SearchTeams(teamName: _):
            return "api/v1/json/3/searchteams.php"
        case .LookupTeam(teamID: _):
            return "api/v1/json/3/lookupteam.php"
        case .LookupEquipment(teamID: _):
            return "api/v1/json/3/lookupequipment.php"
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
        case .GetListTeams(leagueName: let leagueName, sportName: let sportName, countryName: let countryName):
            if !leagueName.isEmpty {
                return ["l": leagueName]
            } else {
                return ["s": sportName, "c": countryName]
            }
        case .SearchTeams(teamName: let teamName):
            return ["t": teamName]
        case .LookupTeam(teamID: let teamID):
            return ["id": teamID]
        case .LookupEquipment(teamID: let teamID):
            return ["id": teamID]
        }
    }
    
    var body: Data? {
        nil
    }
}

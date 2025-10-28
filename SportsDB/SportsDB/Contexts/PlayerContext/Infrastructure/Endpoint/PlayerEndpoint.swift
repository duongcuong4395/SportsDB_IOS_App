//
//  PlayerEndpoint.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

enum PlayerEndpoint<T: Decodable> {
    case SearchPlayers(playerName: String)
    
    case LookupPlayerAPIResponse(playerID: String)
    case LookupPlayerHonours(playerID: String)
    
    case LookupFormerTeams(playerID: String)
    
    case LookupMilestones(playerID: String)
    
    case LookupContracts(playerID: String)
    
    case LookupAllPlayers(teamID: String)
}

import Foundation
import Alamofire
import Networking

extension PlayerEndpoint: HttpRouter {
    typealias responseDataType = T
    
    var baseURL: String {
        AppUtility.SportBaseURL
    }
    
    var path: String {
        switch self {
        case .LookupPlayerAPIResponse(playerID: _):
            return "api/v1/json/3/lookupplayer.php"
        case .SearchPlayers(playerName: _):
            return "api/v1/json/3/searchplayers.php"
        case .LookupPlayerHonours(playerID: _):
            return "api/v1/json/3/lookuphonours.php"
        case .LookupFormerTeams(playerID: _):
            return "api/v1/json/3/lookupformerteams.php"
        case .LookupMilestones(playerID: _):
            return "api/v1/json/3/lookupmilestones.php"
        case .LookupContracts(playerID: _):
            return "api/v1/json/3/lookupcontracts.php"
        case .LookupAllPlayers(teamID: _):
            return "api/v1/json/123/lookup_all_players.php"
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
        case .LookupPlayerAPIResponse(playerID: let playerID):
            return ["id": playerID]
        case .SearchPlayers(playerName: let playerName):
            return ["p": playerName]
        case .LookupPlayerHonours(playerID: let playerID):
            return ["id": playerID]
        case .LookupFormerTeams(playerID: let playerID):
            return ["id": playerID]
        case .LookupMilestones(playerID: let playerID):
            return ["id": playerID]
        case .LookupContracts(playerID: let playerID):
            return ["id": playerID]
        case .LookupAllPlayers(teamID: let teamID):
            return ["id": teamID]
        }
    }
    
    var body: Data? {
        nil
    }
    
    
}

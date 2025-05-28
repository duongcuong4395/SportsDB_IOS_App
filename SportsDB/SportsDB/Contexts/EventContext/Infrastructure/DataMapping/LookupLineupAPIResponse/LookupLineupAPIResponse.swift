//
//  LookupLineupAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

struct LookupLineupAPIResponse: Codable {
    var lineups: [EventLineupDTO]
    
    enum CodingKeys: String, CodingKey {
        case lineups = "lineup"
    }
}

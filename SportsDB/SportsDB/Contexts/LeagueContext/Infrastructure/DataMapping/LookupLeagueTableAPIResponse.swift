//
//  LookupLeagueTableAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

// MARK: - LookupLeagueTableAPIResponse
struct LookupLeagueTableAPIResponse: Codable {
    let leagueTable: [LeagueTableDTO]
    
    enum CodingKeys: String, CodingKey {
        case leagueTable = "table"
    }
}

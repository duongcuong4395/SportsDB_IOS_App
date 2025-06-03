//
//  LookupEventStatisticsAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

struct LookupEventStatisticsAPIResponse: Codable {
    var eventStatistics: [EventStatisticsDTO]?
    
    enum CodingKeys: String, CodingKey {
        case eventStatistics = "eventstats"
    }
}

//
//  LookupEventsPastLeagueAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 1/6/25.
//

struct LookupEventsPastLeagueAPIResponse: Codable {
    var events: [EventDTO]?
    
    enum CodingKeys: String, CodingKey {
        case events = "events"
    }
}

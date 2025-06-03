//
//  LookupListEventsAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

struct LookupListEventsAPIResponse: Codable {
    var events: [EventDTO]?
    
    enum CodingKeys: String, CodingKey {
        case events = "events"
    }
}

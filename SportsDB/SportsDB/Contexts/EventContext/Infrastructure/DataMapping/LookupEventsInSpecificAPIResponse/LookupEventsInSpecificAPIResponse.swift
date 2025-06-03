//
//  LookupEventsInSpecificAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 31/5/25.
//

struct LookupEventsInSpecificAPIResponse: Codable {
    var events: [EventDTO]?
    
    enum CodingKeys: String, CodingKey {
        case events = "events"
    }
}

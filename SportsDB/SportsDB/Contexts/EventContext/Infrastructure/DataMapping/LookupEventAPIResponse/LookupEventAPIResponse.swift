//
//  LookupEventAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

struct LookupEventAPIResponse: Codable {
    var events: [EventDTO]
    enum CodingKeys: String, CodingKey {
        case events = "events"
    }
}

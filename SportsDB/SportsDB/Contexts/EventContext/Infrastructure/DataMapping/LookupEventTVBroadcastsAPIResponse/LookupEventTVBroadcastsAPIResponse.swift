//
//  LookupEventTVBroadcastsAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//

struct LookupEventTVBroadcastsAPIResponse: Codable {
    var eventTVBroadcasts: [EventTVBroadcastDTO]?
    
    enum CodingKeys: String, CodingKey {
        case eventTVBroadcasts = "tvevent"
    }
}

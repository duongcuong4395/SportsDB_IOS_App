//
//  LookupEventVenueAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//

struct LookupEventVenueAPIResponse: Codable {
    var eventVenues: [EventVenueDTO]
    
    enum CodingKeys: String, CodingKey {
        case eventVenues = "venues"
    }
}

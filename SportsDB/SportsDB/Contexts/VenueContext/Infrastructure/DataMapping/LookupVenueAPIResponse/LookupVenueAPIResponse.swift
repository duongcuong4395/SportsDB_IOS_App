//
//  LookupEventVenueAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//

struct LookupVenueAPIResponse: Codable {
    var venues: [VenueDTO]
    
    enum CodingKeys: String, CodingKey {
        case venues = "venues"
    }
}

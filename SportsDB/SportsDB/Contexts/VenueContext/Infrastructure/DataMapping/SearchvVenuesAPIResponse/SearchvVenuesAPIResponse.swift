//
//  SearchvVenuesAPIResponse.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct SearchvVenuesAPIResponse: Codable {
    var venues: [VenueDTO]
    
    enum CodingKeys: String, CodingKey {
        case venues = "venues"
    }
}

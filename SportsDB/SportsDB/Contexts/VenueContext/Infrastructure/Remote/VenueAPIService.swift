//
//  VenueAPIService.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

final class VenueAPIService: APIExecution, VenueRepository {
    func searchVenues(venueName: String) async throws -> [Venue] {
        let response: SearchvVenuesAPIResponse = try await sendRequest(for: VenueEndpoint<SearchvVenuesAPIResponse>.SearchVenues(venueName: venueName))
        
        return response.venues.map { $0.toDomain() }
    }
    
    func lookupVenue(eventID: String) async throws -> [Venue] {
        let response: LookupVenueAPIResponse = try await sendRequest(for: VenueEndpoint<LookupVenueAPIResponse>.LookupVenue(eventID: eventID))
        
        return response.venues.map { $0.toDomain() }
    }
    
    
}

//
//  LookupEventVenueUseCase.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//

struct LookupVenueUseCase {
    let repository: VenueRepository
    
    func execute(eventID: String) async throws -> [Venue] {
        try await repository.lookupVenue(eventID: eventID)
    }
}

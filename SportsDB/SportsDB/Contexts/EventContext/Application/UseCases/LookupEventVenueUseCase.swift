//
//  LookupEventVenueUseCase.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//

struct LookupEventVenueUseCase {
    let repository: EventRepository
    
    func execute(eventID: String) async throws -> [EventVenue] {
        try await repository.lookupEventVenue(eventID: eventID)
    }
}

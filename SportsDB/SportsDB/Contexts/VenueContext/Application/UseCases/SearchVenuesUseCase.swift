//
//  SearchVenuesUseCase.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

struct SearchVenuesUseCase {
    let repository: VenueRepository
    
    func execute(venueName: String) async throws -> [Venue] {
        try await repository.searchVenues(venueName: venueName)
    }
}

//
//  VenueRepository.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

protocol VenueRepository {
    func lookupVenue(eventID: String) async throws -> [Venue]
    func searchVenues(venueName: String) async throws -> [Venue]
}

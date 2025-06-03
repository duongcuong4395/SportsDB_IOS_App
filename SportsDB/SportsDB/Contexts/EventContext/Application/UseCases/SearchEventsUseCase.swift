//
//  SearchEventsUseCase.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

struct SearchEventsUseCase {
    let repository: EventRepository
    
    func execute(eventName: String, season: String)  async throws -> [Event] {
        try await repository.searchEvents(eventName: eventName, season: season)
    }
}

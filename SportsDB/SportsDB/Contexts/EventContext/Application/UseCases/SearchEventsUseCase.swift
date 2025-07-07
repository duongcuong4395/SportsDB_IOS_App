//
//  SearchEventsUseCase.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

class SearchEventsUseCase {
    private let repository: EventRepository
    
    init(repository: EventRepository) {
        self.repository = repository
    }
    
    func execute(eventName: String, season: String)  async throws -> [Event] {
        try await repository.searchEvents(eventName: eventName, season: season)
    }
}

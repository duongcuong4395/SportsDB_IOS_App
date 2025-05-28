//
//  LookupEventResultsUseCase.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

struct LookupEventResultsUseCase {
    let repository: EventRepository
    
    func execute(eventID: String) async throws -> [EventResult] {
        try await repository.lookupEventResults(eventID: eventID)
    }
    
}

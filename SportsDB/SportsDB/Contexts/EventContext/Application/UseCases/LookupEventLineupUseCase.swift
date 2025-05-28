//
//  LookupEventLineupUseCase.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

struct LookupEventLineupUseCase {
    let repository: EventRepository
    
    func execute(eventID: String) async throws -> [EventLineup] {
        try await repository.lookupEventLineup(eventID: eventID)
    }
}

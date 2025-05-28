//
//  LookupEventUseCase.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

struct LookupEventUseCase {
    let repository: EventRepository
    
    func execute(eventID: String) async throws -> [Event] {
        try await repository.lookupEvent(eventID: eventID)
    }
}

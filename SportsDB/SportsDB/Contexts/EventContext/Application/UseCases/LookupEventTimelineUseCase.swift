//
//  LookupEventTimelineUseCase.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

struct LookupEventTimelineUseCase {
    let repository: EventRepository
    
    func execute(eventID: String) async throws -> [EventTimeline] {
        try await repository.lookupEventTimeline(eventID: eventID)
    }
}

//
//  LookupEventTVBroadcastsUseCase.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//

struct LookupEventTVBroadcastsUseCase {
    let repository: EventRepository
    
    func execute(eventID: String) async throws -> [EventTVBroadcast] {
        try await repository.lookupEventTVBroadcasts(eventID: eventID)
        
    }
}

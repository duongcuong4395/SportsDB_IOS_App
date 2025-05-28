//
//  LookupEventStatisticsUseCase.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

struct LookupEventStatisticsUseCase {
    let repository: EventRepository
    
    func execute(eventID: String) async throws -> [EventStatistics] {
        try await repository.lookupEventStatistics(eventID: eventID)
    }
}

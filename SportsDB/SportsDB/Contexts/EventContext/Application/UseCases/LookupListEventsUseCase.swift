//
//  LookupListEventsUseCase.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

struct LookupListEventsUseCase {
    let repository: EventRepository
    
    func execute(leagueID: String, round: String, season: String) async throws -> [Event] {
        try await repository.lookupListEvents(leagueID: leagueID, round: round, season: season)
    }
}

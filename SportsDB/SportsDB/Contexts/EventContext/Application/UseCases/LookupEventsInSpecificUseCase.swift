//
//  LookupEventsInSpecificUseCase.swift
//  SportsDB
//
//  Created by Macbook on 31/5/25.
//

struct LookupEventsInSpecificUseCase {
    let repository: EventRepository
    
    func execute(leagueID: String, season: String) async throws -> [Event] {
        try await repository.lookupEventsInSpecific(leagueID: leagueID, season: season)
    }
}

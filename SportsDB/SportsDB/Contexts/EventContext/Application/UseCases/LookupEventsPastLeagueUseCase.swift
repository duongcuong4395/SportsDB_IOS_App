//
//  LookupEventsPastLeagueUseCase.swift
//  SportsDB
//
//  Created by Macbook on 1/6/25.
//

struct LookupEventsPastLeagueUseCase {
    let repository: EventRepository
    
    func execute(leagueID: String) async throws -> [Event] {
        try await repository.lookupEventsPastLeague(leagueID: leagueID)
    }
}

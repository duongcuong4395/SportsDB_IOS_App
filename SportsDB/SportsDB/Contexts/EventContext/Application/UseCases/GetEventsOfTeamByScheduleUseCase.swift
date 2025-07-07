//
//  GetEventsOfTeamByScheduleUseCase.swift
//  SportsDB
//
//  Created by Macbook on 4/6/25.
//

struct GetEventsOfTeamByScheduleUseCase {
    let repository: EventRepository
    
    func execute(of teamID: String, by schedule: NextAndPrevious) async throws -> [Event] {
        try await repository.getEvents(of: teamID, by: schedule)
    }
}

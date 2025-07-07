//
//  EventsOfTeamByScheduleViewModel.swift
//  SportsDB
//
//  Created by Macbook on 10/6/25.
//

import SwiftUI

@MainActor
class EventsOfTeamByScheduleViewModel: ObservableObject {
    @Published var eventsForPrevious: ModelsStatus<[Event]> = .Idle
    @Published var eventsForNext: ModelsStatus<[Event]> = .Idle
    
    private var getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase
    
    init(getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase) {
        
        self.getEventsOfTeamByScheduleUseCase = getEventsOfTeamByScheduleUseCase
    }
    
    func selectTeam(by team: Team) {
        Task {
            let resForPrevious = try await self.getEventsOfTeamByScheduleUseCase.execute(of: team.idTeam ?? "", by: .Previous)
            
            let resForNext = try await self.getEventsOfTeamByScheduleUseCase.execute(of: team.idTeam ?? "", by: .Next)
            try await Task.sleep(nanoseconds: 500_000_000)
            eventsForNext = .Success(model: resForNext)
            eventsForPrevious = .Success(model: resForPrevious)
        }
    }
}

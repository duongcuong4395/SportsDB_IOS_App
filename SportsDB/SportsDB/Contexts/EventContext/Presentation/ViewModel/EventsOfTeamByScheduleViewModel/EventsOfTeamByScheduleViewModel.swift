//
//  EventsOfTeamByScheduleViewModel.swift
//  SportsDB
//
//  Created by Macbook on 10/6/25.
//

import SwiftUI

@MainActor
class EventsOfTeamByScheduleViewModel: ObservableObject {
    //@Published var eventsForPrevious: ModelsStatus<[Event]> = .idle
    //@Published var eventsForNext: ModelsStatus<[Event]> = .idle
    
    @Published var eventsOfTeamByUpcomingVM: EventsOfTeamByUpcomingViewModel
    @Published var eventsOfTeamByResultsVM: EventsOfTeamByResultsViewModel
    
    private var getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase
    
    init(getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase) {
        self.getEventsOfTeamByScheduleUseCase = getEventsOfTeamByScheduleUseCase
        
        self.eventsOfTeamByUpcomingVM = EventsOfTeamByUpcomingViewModel(getEventsOfTeamByScheduleUseCase: self.getEventsOfTeamByScheduleUseCase)
        
        self.eventsOfTeamByResultsVM = EventsOfTeamByResultsViewModel(getEventsOfTeamByScheduleUseCase: self.getEventsOfTeamByScheduleUseCase)
    }
    
    func selectTeam(by team: Team) {
        eventsOfTeamByUpcomingVM.getEventsUpcoming(by: team)
        eventsOfTeamByResultsVM.getEventsResults(by: team)
        
        /*
        Task {
            let resForPrevious = try await self.getEventsOfTeamByScheduleUseCase.execute(of: team.idTeam ?? "", by: .Previous)
            
            let resForNext = try await self.getEventsOfTeamByScheduleUseCase.execute(of: team.idTeam ?? "", by: .Next)
            try await Task.sleep(nanoseconds: 500_000_000)
            eventsForNext = .success(data: resForNext)
            eventsForPrevious = .success(data: resForPrevious)
        }
         */
    }
    
    func resetAll() {
        eventsOfTeamByUpcomingVM.resetAll()
        eventsOfTeamByResultsVM.resetAll()
        //eventsForPrevious = .idle
        //eventsForNext = .idle
    }
}

@MainActor
class EventsOfTeamByUpcomingViewModel: EventsViewModel {
    @Published var eventsStatus: ModelsStatus<[Event]> = .idle
    
    var events: [Event] {
        eventsStatus.data ?? []
    }
    
    private var getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase
    
    init(getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase) {
        self.getEventsOfTeamByScheduleUseCase = getEventsOfTeamByScheduleUseCase
    }
    
    func getEventsUpcoming(by team: Team) {
        eventsStatus = .loading
        Task {
            do {
                let resForPrevious = try await self.getEventsOfTeamByScheduleUseCase.execute(of: team.idTeam ?? "", by: .Next)
                
                //try await Task.sleep(nanoseconds: 500_000_000)
                eventsStatus = .success(data: resForPrevious)
            } catch {
                eventsStatus = .failure(error: error.localizedDescription)
            }
        }
    }
}

@MainActor
class EventsOfTeamByResultsViewModel: EventsViewModel {
    @Published var eventsStatus: ModelsStatus<[Event]> = .idle
    
    var events: [Event] {
        eventsStatus.data ?? []
    }
    
    private var getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase
    
    init(getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase) {
        self.getEventsOfTeamByScheduleUseCase = getEventsOfTeamByScheduleUseCase
    }
    
    func getEventsResults(by team: Team) {
        eventsStatus = .loading
        Task {
            do {
                let resForPrevious = try await self.getEventsOfTeamByScheduleUseCase.execute(of: team.idTeam ?? "", by: .Previous)
                
                //try await Task.sleep(nanoseconds: 500_000_000)
                eventsStatus = .success(data: resForPrevious)
            } catch {
                eventsStatus = .failure(error: error.localizedDescription)
            }
        }
    }
}

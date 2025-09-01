//
//  EventsOfTeamByScheduleViewModel.swift
//  SportsDB
//
//  Created by Macbook on 10/6/25.
//

import SwiftUI

@MainActor
class EventsOfTeamByScheduleViewModel: ObservableObject {
    @Published var eventsOfTeamByUpcomingVM: EventsOfTeamByUpcomingViewModel
    @Published var eventsOfTeamByResultsVM: EventsOfTeamByResultsViewModel
    
    private var getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase
    
    init(getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase) {
        self.getEventsOfTeamByScheduleUseCase = getEventsOfTeamByScheduleUseCase
        
        self.eventsOfTeamByUpcomingVM = EventsOfTeamByUpcomingViewModel(getEventsOfTeamByScheduleUseCase: self.getEventsOfTeamByScheduleUseCase)
        
        self.eventsOfTeamByResultsVM = EventsOfTeamByResultsViewModel(getEventsOfTeamByScheduleUseCase: self.getEventsOfTeamByScheduleUseCase)
    }
    
    func getEvents(by team: Team) async {
        async let a: (ModelsStatus<[Event]>) = eventsOfTeamByUpcomingVM.getEventsUpcoming(by: team)
        async let b: (ModelsStatus<[Event]>) = eventsOfTeamByResultsVM.getEventsResults(by: team)
        let res = await (a, b)
        eventsOfTeamByUpcomingVM.eventsStatus = res.0
        eventsOfTeamByResultsVM.eventsStatus = res.1
    }
    
    func resetAll() {
        eventsOfTeamByUpcomingVM.resetAll()
        eventsOfTeamByResultsVM.resetAll()
    }
}

@MainActor
class EventsOfTeamByUpcomingViewModel: GeneralEventManagement {
    @Published var eventsStatus: ModelsStatus<[Event]> = .idle
    
    var events: [Event] {
        eventsStatus.data ?? []
    }
    
    private var getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase
    
    init(getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase) {
        self.getEventsOfTeamByScheduleUseCase = getEventsOfTeamByScheduleUseCase
    }
    
    func getEventsUpcoming(by team: Team) async -> ModelsStatus<[Event]> {
        eventsStatus = .loading
        do {
            let resForPrevious = try await self.getEventsOfTeamByScheduleUseCase.execute(of: team.idTeam ?? "", by: .Next)
            
            //try await Task.sleep(nanoseconds: 500_000_000)
            //eventsStatus = .success(data: resForPrevious)
            return .success(data: resForPrevious)
        } catch {
            
            //eventsStatus = .failure(error: error.localizedDescription)
            return .failure(error: error.localizedDescription)
        }
    }
}

@MainActor
class EventsOfTeamByResultsViewModel: GeneralEventManagement {
    @Published var eventsStatus: ModelsStatus<[Event]> = .idle
    
    var events: [Event] {
        eventsStatus.data ?? []
    }
    
    private var getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase
    
    init(getEventsOfTeamByScheduleUseCase: GetEventsOfTeamByScheduleUseCase) {
        self.getEventsOfTeamByScheduleUseCase = getEventsOfTeamByScheduleUseCase
    }
    
    func getEventsResults(by team: Team) async -> ModelsStatus<[Event]> {
        eventsStatus = .loading
        do {
            let resForPrevious = try await self.getEventsOfTeamByScheduleUseCase.execute(of: team.idTeam ?? "", by: .Previous)
            
            //try await Task.sleep(nanoseconds: 500_000_000)
            //eventsStatus = .success(data: resForPrevious)
            return .success(data: resForPrevious)
        } catch {
            //eventsStatus = .failure(error: error.localizedDescription)
            return .failure(error: error.localizedDescription)
        }
    }
}

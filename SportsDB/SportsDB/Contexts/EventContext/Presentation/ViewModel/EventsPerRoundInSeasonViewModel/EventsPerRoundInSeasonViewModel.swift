//
//  EventsPerRoundInSeasonViewModel.swift
//  SportsDB
//
//  Created by Macbook on 9/6/25.
//

import SwiftUI

@MainActor
class EventsPerRoundInSeasonViewModel: ObservableObject {
    @Published var events: ModelsStatus<[Event]> = .Idle
    
    private var lookupListEventsUseCase: LookupListEventsUseCase
    
    init(lookupListEventsUseCase: LookupListEventsUseCase) {
        self.lookupListEventsUseCase = lookupListEventsUseCase
    }
    
    @MainActor
    func getEvents(of leagueID: String, per round: String, in season: String) {
        Task {
            events = .Progressing
            let res = try await self.lookupListEventsUseCase.execute(leagueID: leagueID, round: round, season: season)
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            events = .Success(model: res)
        }
    }
}

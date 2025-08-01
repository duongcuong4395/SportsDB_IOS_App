//
//  EventsRecentViewModel.swift
//  SportsDB
//
//  Created by Macbook on 9/6/25.
//

import SwiftUI

@MainActor
class EventsRecentOfLeagueViewModel: ObservableObject {
    @Published var events: ModelsStatus<[Event]> = .idle
    
    private var lookupEventsPastLeagueUseCase: LookupEventsPastLeagueUseCase
    
    init(lookupEventsPastLeagueUseCase: LookupEventsPastLeagueUseCase) {
        self.lookupEventsPastLeagueUseCase = lookupEventsPastLeagueUseCase
    }

    func getEvents(by leagueID: String) {
        Task {
            events = .loading
            let res = try await lookupEventsPastLeagueUseCase.execute(leagueID: leagueID)
            try? await Task.sleep(nanoseconds: 500_000_000)
            events = .success(data: res)
        }
    }
    
    func resetAll() {
        self.events = .idle
    }
}

//
//  EventsRecentViewModel.swift
//  SportsDB
//
//  Created by Macbook on 9/6/25.
//

import SwiftUI

@MainActor
class EventsRecentOfLeagueViewModel: EventsViewModel {
    
    
    //@Published private(set) var eventsStatus: ModelsStatus<[Event]> = .idle
    @Published var eventsStatus: ModelsStatus<[Event]> = .idle
    
    var events: [Event] {
        eventsStatus.data ?? []
    }
    
    var hasData: Bool {
        eventsStatus.isSuccess
    }
    
    private var lookupEventsPastLeagueUseCase: LookupEventsPastLeagueUseCase
    
    init(lookupEventsPastLeagueUseCase: LookupEventsPastLeagueUseCase) {
        self.lookupEventsPastLeagueUseCase = lookupEventsPastLeagueUseCase
    }

    func getEvents(by leagueID: String) {
        Task {
            do {
                eventsStatus = .loading
                let res = try await lookupEventsPastLeagueUseCase.execute(leagueID: leagueID)
                try? await Task.sleep(nanoseconds: 500_000_000)
                eventsStatus = .success(data: res)
            } catch {
                eventsStatus = .failure(error: error.localizedDescription)
            }
            
        }
    }
    
    /*
     
     func resetAll() {
         self.eventsStatus = .idle
     }
     
    func updateEvent(from oldItem: Event, with newItem: Event) {
        self.eventsStatus = eventsStatus.updateElement(where: { oldEvent in
            oldEvent.idEvent == oldItem.idEvent
        }, with: newItem)
    }
     */
}

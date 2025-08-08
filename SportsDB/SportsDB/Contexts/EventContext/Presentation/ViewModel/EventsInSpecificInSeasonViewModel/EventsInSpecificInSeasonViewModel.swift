//
//  EventsInSpecificInSeasonViewModel.swift
//  SportsDB
//
//  Created by Macbook on 9/6/25.
//

import SwiftUI

@MainActor
class EventsInSpecificInSeasonViewModel: ObservableObject {
    @Published var eventsStatus: ModelsStatus<[Event]> = .idle
    
    var events: [Event] {
        eventsStatus.data ?? []
    }
    
    private var lookupEventsInSpecificUseCase: LookupEventsInSpecificUseCase
    
    init(lookupEventsInSpecificUseCase: LookupEventsInSpecificUseCase) {
        self.lookupEventsInSpecificUseCase = lookupEventsInSpecificUseCase
    }
    
    func getEvents(leagueID: String, season: String) async {
        Task {
            do {
                eventsStatus = .loading
                let res = try await self.lookupEventsInSpecificUseCase.execute(leagueID: leagueID, season: season)
                // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
                try await Task.sleep(nanoseconds: 500_000_000)
                eventsStatus = .success(data: res)
            } catch {
                eventsStatus = .failure(error: error.localizedDescription)
            }
             
        }
    }
    
    func resetAll() {
        self.eventsStatus = .idle
    }
    
    func updateItem(from oldItem: Event, with newItem: Event) {
        self.eventsStatus = eventsStatus.updateElement(where: { oldEvent in
            oldEvent.idEvent == oldItem.idEvent
        }, with: newItem)
    }
}

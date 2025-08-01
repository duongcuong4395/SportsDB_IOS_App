//
//  EventListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation
import SwiftUI

@MainActor
class EventListViewModel: ObservableObject {
    @Published var eventsBySearch: [Event] = []
    @Published var eventsByLookup: [Event] = []
    
    @Published var eventsResult: [EventResult] = []
    @Published var eventsPastLeague: [Event] = []
    
    @Published var lineups: [EventLineup] = []
    @Published var timelines: [EventTimeline] = []
    @Published var statistics: [EventStatistics] = []
    @Published var tvBroadcasts: [EventTVBroadcast] = []
    
    @Published var currentRound: Int = 1
    @Published var hasNextRound: Bool = true
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var searchEventsUseCase: SearchEventsUseCase
    private var lookupEventUseCase: LookupEventUseCase
    
    init(searchEventsUseCase: SearchEventsUseCase,
         lookupEventUseCase: LookupEventUseCase
    ) {
        self.searchEventsUseCase = searchEventsUseCase
        self.lookupEventUseCase = lookupEventUseCase
    }
}

extension EventListViewModel {
    func resetAll() {
        self.eventsBySearch = []
        self.eventsByLookup = []
        
        self.eventsResult = []
        self.eventsPastLeague = []
        
        self.lineups = []
        self.timelines = []
        self.statistics = []
        self.tvBroadcasts = []
        
        self.currentRound = 1
        self.hasNextRound = true
        
        self.isLoading = false
        self.errorMessage = nil
    }
    
}

extension EventListViewModel {
    func setCurrentRound(by round: Int, competion: @escaping (Int) ->  Void) {
        self.currentRound = round
        competion(self.currentRound)
    }
    
    func setNextCurrentRound() {
        self.currentRound += 1
    }
    
    func setPreviousCurrentRound() {
        self.currentRound -= 1
    }
    
    func sesetEventsBySearch() {
        self.eventsBySearch = []
    }
}

extension EventListViewModel {
    func searchEvents(eventName: String, season: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            self.eventsBySearch = try await searchEventsUseCase.execute(eventName: eventName, season: season)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func lookupEvent(eventID: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.eventsByLookup = try await lookupEventUseCase.execute(eventID: eventID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

extension EventListViewModel {
    
    
    func getEventExample() -> Event {
        if let jsonEventDTOData = eventExampleJson.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let eventDTO = try decoder.decode(EventDTO.self, from: jsonEventDTOData)
                let domainModel = eventDTO.toDomain()
                return domainModel
            } catch {
                print("❌ JSON decode failed: \(error)")
            }
        }
        
        return Event()
    }
    
}





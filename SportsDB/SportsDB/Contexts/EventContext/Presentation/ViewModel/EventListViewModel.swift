//
//  EventListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation
import SwiftUI

class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []
    
    @Published var eventsResult: [EventResult] = []
    @Published var lineups: [EventLineup] = []
    @Published var timelines: [EventTimeline] = []
    @Published var statistics: [EventStatistics] = []
    @Published var tvBroadcasts: [EventTVBroadcast] = []
    @Published var venues: [EventVenue] = []
    
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
    
    func searchEvents(eventName: String, season: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            self.events = try await searchEventsUseCase.execute(eventName: eventName, season: season)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func LookupEvent(eventID: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.events = try await lookupEventUseCase.execute(eventID: eventID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}

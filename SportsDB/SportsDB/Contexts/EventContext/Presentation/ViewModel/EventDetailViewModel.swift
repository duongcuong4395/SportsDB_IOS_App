//
//  EventDetailViewModel.swift
//  SportsDB
//
//  Created by Macbook on 28/5/25.
//

import SwiftUI

class EventDetailViewModel: EventsViewModel {
    @Published var eventsStatus: ModelsStatus<[Event]> = .idle
    
    var events: [Event] {
        eventsStatus.data ?? []
    }
    
    @Published var eventSelected: Event?
 
    @Published var eventsResult: [EventResult] = []
    @Published var lineups: [EventLineup] = []
    @Published var timelines: [EventTimeline] = []
    @Published var statistics: [EventStatistics] = []
    @Published var tvBroadcasts: [EventTVBroadcast] = []
    
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var lookupEventResultsUseCase: LookupEventResultsUseCase
    private var lookupEventLineupUseCase: LookupEventLineupUseCase
    private var lookupEventTimelineUseCase: LookupEventTimelineUseCase
    private var lookupEventStatisticsUseCase: LookupEventStatisticsUseCase
    private var lookupEventTVBroadcastsUseCase: LookupEventTVBroadcastsUseCase
    
    
    init(
         lookupEventResultsUseCase: LookupEventResultsUseCase,
         lookupEventLineupUseCase: LookupEventLineupUseCase,
         lookupEventTimelineUseCase: LookupEventTimelineUseCase,
         lookupEventStatisticsUseCase: LookupEventStatisticsUseCase,
         lookupEventTVBroadcastsUseCase: LookupEventTVBroadcastsUseCase
         
    ) {
        self.lookupEventResultsUseCase = lookupEventResultsUseCase
        self.lookupEventLineupUseCase = lookupEventLineupUseCase
        self.lookupEventTimelineUseCase = lookupEventTimelineUseCase
        self.lookupEventStatisticsUseCase = lookupEventStatisticsUseCase
        self.lookupEventTVBroadcastsUseCase = lookupEventTVBroadcastsUseCase
    }
}


extension EventDetailViewModel {
    func setEventDetail(_ event: Event) {
        self.eventsStatus = .success(data: [event])
    }
}

extension EventDetailViewModel {
    func lookupEventResults(eventID: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            self.eventsResult = try await lookupEventResultsUseCase.execute(eventID: eventID)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func lookupEventLineup(eventID: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            lineups = try await lookupEventLineupUseCase.execute(eventID: eventID)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func lookupEventTimeline(eventID: String) async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            self.timelines = try await lookupEventTimelineUseCase.execute(eventID: eventID)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func lookupEventStatistics(eventID: String) async {
        isLoading = true
        
        defer { isLoading = false }
        
        do{
            statistics = try await lookupEventStatisticsUseCase.execute(eventID: eventID)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func lookupEventTVBroadcasts(eventID: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            tvBroadcasts = try await lookupEventTVBroadcastsUseCase.execute(eventID: eventID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

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
    @Published var eventsByLookupList: [Event] = []
    @Published var eventsResult: [EventResult] = []
    @Published var eventsInSpecific: [Event] = []
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
    private var lookupListEventsUseCase: LookupListEventsUseCase
    private var lookupEventsInSpecificUseCase: LookupEventsInSpecificUseCase
    private var lookupEventsPastLeagueUseCase: LookupEventsPastLeagueUseCase
    
    init(searchEventsUseCase: SearchEventsUseCase,
         lookupEventUseCase: LookupEventUseCase,
         lookupListEventsUseCase: LookupListEventsUseCase,
         lookupEventsInSpecificUseCase: LookupEventsInSpecificUseCase,
         lookupEventsPastLeagueUseCase: LookupEventsPastLeagueUseCase
         
    ) {
        
        self.searchEventsUseCase = searchEventsUseCase
        self.lookupEventUseCase = lookupEventUseCase
        self.lookupListEventsUseCase = lookupListEventsUseCase
        self.lookupEventsInSpecificUseCase = lookupEventsInSpecificUseCase
        self.lookupEventsPastLeagueUseCase = lookupEventsPastLeagueUseCase
    }
}

extension EventListViewModel {
    func setCurrentRound(by round: Int) {
        self.currentRound = round
    }
    
    func setNextCurrentRound() {
        self.currentRound += 1
    }
    
    func setPreviousCurrentRound() {
        self.currentRound -= 1
    }
    
    func resetEventsByLookupList() {
        self.eventsByLookupList = []
    }
    
    func sesetEventsBySearch() {
        self.eventsBySearch = []
    }
    
    func resetEventsInSpecific() {
        self.eventsInSpecific = []
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
    
    func lookupListEvents(leagueID: String, round: String, season: String) async {
        isLoading = true
        defer { isLoading = false }
        print("")
        do {
            self.eventsByLookupList = try await lookupListEventsUseCase.execute(leagueID: leagueID, round: round, season: season)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
    func lookupEventsInSpecific(leagueID: String, season: String) async {
        isLoading = true
        defer { isLoading = false }
        print("")
        do {
            self.eventsInSpecific = try await lookupEventsInSpecificUseCase.execute(leagueID: leagueID, season: season)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func lookupEventsPastLeague(leagueID: String) async {
        isLoading = true
        defer { isLoading = false }
        print("")
        do {
            self.eventsPastLeague = try await lookupEventsPastLeagueUseCase.execute(leagueID: leagueID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

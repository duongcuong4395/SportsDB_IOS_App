//
//  EventAPIService.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Networking

final class EventAPIService: EventRepository, APIExecution {
    func getEvents(of team: String, by schedule: NextAndPrevious) async throws -> [Event] {
        switch schedule {
        case .Next:
            let response: GetEventsOfTeamByNextAPIResponse = try await sendRequest(for: EventEndpoint<GetEventsOfTeamByNextAPIResponse>.GetEvents(of: team, by: schedule))
            
            guard let events = response.events else { return [] }
            
            return events.map { $0.toDomain() }
        case .Previous:
            let response: GetEventsOfTeamByPreviousAPIResponse = try await sendRequest(for: EventEndpoint<GetEventsOfTeamByPreviousAPIResponse>.GetEvents(of: team, by: schedule))
            
            guard let events = response.events else { return [] }
            
            return events.map { $0.toDomain() }
        }
        
    }
    
    func lookupEventsPastLeague(leagueID: String) async throws -> [Event] {
        let response: LookupEventsPastLeagueAPIResponse = try await sendRequest(for: EventEndpoint<LookupEventsPastLeagueAPIResponse>.LookupEventsPastLeague(leagueID: leagueID))
        
        guard let events = response.events else { return [] }
        
        return events.map { $0.toDomain() }
    }
    
    func lookupEventsInSpecific(leagueID: String, season: String) async throws -> [Event] {
        
        let response: LookupEventsInSpecificAPIResponse = try await sendRequest(for: EventEndpoint<LookupEventsInSpecificAPIResponse>.LookupEventsInSpecific(leagueID: leagueID, season: season))
        
        guard let events = response.events else { return [] }
        
        return events.map { $0.toDomain() }
    }
    
    func lookupListEvents(leagueID: String, round: String, season: String) async throws -> [Event] {
        let response: LookupListEventsAPIResponse = try await sendRequest(for: EventEndpoint<LookupListEventsAPIResponse>.LookupListEvents(leagueID: leagueID, round: round, season: season))
        
        guard let events = response.events else { return [] }
        
        return events.map { $0.toDomain() }
    }
    
    
    
    func lookupEventTVBroadcasts(eventID: String) async throws -> [EventTVBroadcast] {
        let response: LookupEventTVBroadcastsAPIResponse = try await sendRequest(for: EventEndpoint<LookupEventTVBroadcastsAPIResponse>.LookupEventTVBroadcasts(eventID: eventID))
        
        guard let eventTVBroadcasts = response.eventTVBroadcasts else { return [] }
        
        return eventTVBroadcasts.map { $0.toDomain() }
    }
    
    func lookupEventStatistics(eventID: String) async throws -> [EventStatistics] {
        let response: LookupEventStatisticsAPIResponse = try await sendRequest(for: EventEndpoint<LookupEventStatisticsAPIResponse>.LookupEventStatistics(eventID: eventID))
        
        guard let eventStatistics = response.eventStatistics else { return [] }
        
        return eventStatistics.map { $0.toDomain() }
    }
    
    func lookupEventTimeline(eventID: String) async throws -> [EventTimeline] {
        let response: LookupEventTimelineAPIResponse = try await sendRequest(for: EventEndpoint<LookupEventTimelineAPIResponse>.LookupEventTimeline(eventID: eventID))
        
        guard let timelines = response.timelines else { return [] }
        
        return timelines.map { $0.toDomain() }
    }
    
    func lookupEventLineup(eventID: String) async throws -> [EventLineup] {
        
        let response: LookupLineupAPIResponse = try await sendRequest(for: EventEndpoint<LookupLineupAPIResponse>.LookupEventLineup(eventID: eventID))
        
        guard let lineups = response.lineups else { return [] }
        
        return lineups.map { $0.toDomain() }
    }
    
    func lookupEventResults(eventID: String) async throws -> [EventResult] {
        let response: LookupEventResultsAPIResponse = try await sendRequest(for: EventEndpoint<LookupEventResultsAPIResponse>.LookupEventResults(eventID: eventID))
        
        guard let results = response.results else { return [] }
        
        return results.map { $0.toDomain() }
    }
    
    func lookupEvent(eventID: String) async throws -> [Event] {
        let response: LookupEventAPIResponse = try await sendRequest(for: EventEndpoint<LookupEventAPIResponse>.LookupEvent(eventID: eventID))
        
        guard let events = response.events else { return [] }
        
        return events.map { $0.toDomain() }
    }
    
    func searchEvents(eventName: String, season: String) async throws -> [Event] {
        let response: SearchEventsAPIResponse = try await sendRequest(for: EventEndpoint<SearchEventsAPIResponse>.SearchEvents(eventName: eventName, season: season))
        
        guard let events = response.events else { return [] }
        
        return events.map { $0.toDomain() }
    }
    
    
}

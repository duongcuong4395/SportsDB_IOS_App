//
//  EventAPIService.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

final class EventAPIService: EventRepository, APIExecution {
    
    
    func lookupEventTVBroadcasts(eventID: String) async throws -> [EventTVBroadcast] {
        let response: LookupEventTVBroadcastsAPIResponse = try await sendRequest(for: EventEndpoint<LookupEventTVBroadcastsAPIResponse>.LookupEventTVBroadcasts(eventID: eventID))
        
        return response.eventTVBroadcasts.map { $0.toDomain() }
    }
    
    func lookupEventStatistics(eventID: String) async throws -> [EventStatistics] {
        let response: LookupEventStatisticsAPIResponse = try await sendRequest(for: EventEndpoint<LookupEventStatisticsAPIResponse>.LookupEventStatistics(eventID: eventID))
        
        return response.eventStatistics.map { $0.toDomain() }
    }
    
    func lookupEventTimeline(eventID: String) async throws -> [EventTimeline] {
        let response: LookupEventTimelineAPIResponse = try await sendRequest(for: EventEndpoint<LookupEventTimelineAPIResponse>.LookupEventTimeline(eventID: eventID))
        
        return response.timelines.map { $0.toDomain() }
    }
    
    func lookupEventLineup(eventID: String) async throws -> [EventLineup] {
        
        let response: LookupLineupAPIResponse = try await sendRequest(for: EventEndpoint<LookupLineupAPIResponse>.LookupEventLineup(eventID: eventID))
        
        return response.lineups.map { $0.toDomain() }
    }
    
    func lookupEventResults(eventID: String) async throws -> [EventResult] {
        let response: LookupEventResultsAPIResponse = try await sendRequest(for: EventEndpoint<LookupEventResultsAPIResponse>.LookupEventResults(eventID: eventID))
        
        return response.results.map { $0.toDomain() }
    }
    
    func lookupEvent(eventID: String) async throws -> [Event] {
        let response: LookupEventAPIResponse = try await sendRequest(for: EventEndpoint<LookupEventAPIResponse>.LookupEvent(eventID: eventID))
        
        return response.events.map { $0.toDomain() }
    }
    
    func searchEvents(eventName: String, season: String) async throws -> [Event] {
        let response: SearchEventsAPIResponse = try await sendRequest(for: EventEndpoint<SearchEventsAPIResponse>.SearchEvents(eventName: eventName, season: season))
        
        return response.events.map { $0.toDomain() }
    }
    
    
}

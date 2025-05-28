//
//  EventRepository.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

protocol EventRepository {
    func searchEvents(eventName: String, season: String) async throws -> [Event]
    
    func lookupEvent(eventID: String) async throws -> [Event]
    
    func lookupEventResults(eventID: String) async throws -> [EventResult]
    
    func lookupEventLineup(eventID: String) async throws -> [EventLineup]
    
    func lookupEventTimeline(eventID: String) async throws -> [EventTimeline]
    
    func lookupEventStatistics(eventID: String) async throws -> [EventStatistics]
    
    func lookupEventTVBroadcasts(eventID: String) async throws -> [EventTVBroadcast]
    
    func lookupEventVenue(eventID: String) async throws -> [EventVenue]
}

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
    
    
    func lookupListEvents(leagueID: String, round: String, season: String) async throws -> [Event]
    
    func lookupEventsInSpecific(leagueID: String, season: String) async throws -> [Event]
    
    func lookupEventsPastLeague(leagueID: String) async throws -> [Event]
    
    func getEvents(of team: String, by schedule: NextAndPrevious) async throws -> [Event]
}


protocol EventNotificationRepositoryProtocol {
    func checkAuthorized() async -> Bool
    func getAuthorized() async -> Bool
    
    
    func hasNotification(for idEvent: String, into listNotification: [NotificationItem]) -> Bool
    func getNotification(for idEvent: String, into listNotification: [NotificationItem]) async -> NotificationItem?
    func addNotification(_ item: Event) async
    func removeNotification(for idEvent: String) async
}

class EventNotificationRepository: EventNotificationRepositoryProtocol {
    func getAuthorized() async -> Bool {
        return await NotificationManager.shared.requestPermission()
    }
    
    func checkAuthorized() async -> Bool {
        return await NotificationManager.shared.checkPermissionStatus()
    }
    
    func hasNotification(for idEvent: String, into listNotification: [NotificationItem]) -> Bool {
        return (listNotification.first { $0.userInfo["idEvent"] == idEvent } != nil)
    }
    
    func getNotification(for idEvent: String, into listNotification: [NotificationItem] ) async -> NotificationItem? {
        
        return listNotification.first { $0.userInfo["idEvent"] == idEvent }
        /*
        let isAuthorized = await NotificationManager.shared.checkPermissionStatus()
        if isAuthorized {
            //await loadNotifications()
            return listNotification.first { $0.userInfo["idEvent"] == idEvent }
        } else {
            let hasPermission = await NotificationManager.shared.requestPermission()
            //await loadNotifications()
            return listNotification.first { $0.userInfo["idEvent"] == idEvent }
        }
         */
    }
    
    func addNotification(_ item: Event) async {
        guard let noti = item.asNotificationItem else { return }
        NotificationManager.shared.scheduleNotification(noti)
    }
    
    func removeNotification(for idEvent: String) async {
        NotificationManager.shared.cancelNotification(id: idEvent)
    }
}


// MARK: (Local Data) For SwiftData

import SwiftData

protocol EventSwiftDataRepositoryProtocol {
    func fetchEvents() async throws -> [EventSwiftData]
    func addEvent(event: EventSwiftData) async throws
    func deleteEvent(_ event: EventSwiftData) async throws
    func filter(by searchText: String, with sortOption: SortOption) async throws -> [EventSwiftData]
    
    func toggleLike(_ event: EventSwiftData) async throws -> EventSwiftData
    
    func getEvent(by idEvent: String?, or eventName: String?) async -> EventSwiftData?
    func saveEvent() throws
}

final class EventSwiftDataRepository: EventSwiftDataRepositoryProtocol {
    func toggleLike(_ event: EventSwiftData) async throws -> EventSwiftData {
        event.like = !event.like
        try context.save()
        return event
    }
    
    func saveEvent() throws {
        try context.save()
    }
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchEvents() async throws -> [EventSwiftData] {
        let descriptor = FetchDescriptor<EventSwiftData>(sortBy: [SortDescriptor(\.eventName, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func addEvent(event: EventSwiftData) async throws {
        context.insert(event)
        try context.save()
    }
    
    func deleteEvent(_ event: EventSwiftData) async throws {
        context.delete(event)
        try context.save()
    }
    
    func getEvent(by idEvent: String?, or eventName: String?) async -> EventSwiftData? {
        do {
            let predicate: Predicate<EventSwiftData> = #Predicate {
                $0.eventName == eventName || $0.idEvent == idEvent
            }
            
            let fetchDescriptor = FetchDescriptor<EventSwiftData>(predicate: predicate)
            let res = try context.fetch(fetchDescriptor)
            return res.count > 0 ? res[0] : nil
        } catch {
            return nil
        }
    }
    
    
    func filter(by searchText: String, with sortOption: SortOption) async throws -> [EventSwiftData] {
        do {
            
            
            var descriptor = SortDescriptor(\EventSwiftData.eventName, order: .reverse)
            if sortOption == .oldest {
                descriptor = SortDescriptor(\EventSwiftData.eventName, order: .forward)
            }

            let predicate: Predicate<EventSwiftData> = #Predicate {
                searchText.isEmpty || ($0.eventName ?? "").localizedStandardContains(searchText)
            }

            let fetchDescriptor = FetchDescriptor<EventSwiftData>(predicate: predicate, sortBy: [descriptor])
            let events = try context.fetch(fetchDescriptor)
            return events
        } catch {
            print("⚠️ Filter failed:", error)
            return []
        }
    }
    
}

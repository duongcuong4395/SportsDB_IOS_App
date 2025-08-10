//
//  EventSwiftDataRepository.swift
//  SportsDB
//
//  Created by Macbook on 10/8/25.
//

import SwiftUI
import SwiftData

protocol EventSwiftDataRepositoryProtocol {
    func fetchEvents() async throws -> [EventSwiftData]
    func addEvent(event: EventSwiftData) async throws
    func deleteEvent(_ event: EventSwiftData) async throws
    func filter(by searchText: String, with sortOption: SortOption) async throws -> [EventSwiftData]
    
    func isEventExists(idEvent: String?, eventName: String?) -> (isExists: Bool, event: EventSwiftData?)
}

final class EventSwiftDataRepository: EventSwiftDataRepositoryProtocol {
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
    
    func isEventExists(idEvent: String?, eventName: String?) -> (isExists: Bool, event: EventSwiftData?) {
        do {
            let predicate: Predicate<EventSwiftData> = #Predicate {
                $0.eventName == eventName || $0.idEvent == idEvent
            }
            
            let fetchDescriptor = FetchDescriptor<EventSwiftData>(predicate: predicate)
            let res = try context.fetch(fetchDescriptor)
            return (res.count > 0 , res.count > 0 ? res[0] : nil)
        } catch {
            return (false, nil)
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

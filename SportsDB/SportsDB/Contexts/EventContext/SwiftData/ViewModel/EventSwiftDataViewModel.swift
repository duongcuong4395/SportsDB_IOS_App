//
//  EventSwiftDataViewModel.swift
//  SportsDB
//
//  Created by Macbook on 10/8/25.
//

import SwiftUI
import Foundation
import Combine
import SwiftData

enum SortOption {
    case newest, oldest
}

@MainActor
class EventSwiftDataViewModel: ObservableObject {
    @Published var events: [EventSwiftData] = []
    
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                Task { await applyFilter() }
            }
        }
    }
    @Published var sortOption: SortOption = .newest {
        didSet {
            if sortOption != oldValue {
                Task { await applyFilter() }
            }
        }
    }
    
    var context: ModelContext
    var useCase: EventSwiftDataUseCaseProtocol
    
    init(context: ModelContext, useCase: EventSwiftDataUseCaseProtocol) {
        self.context = context
        self.useCase = useCase
        Task {
            await loadEvents()
        }
    }
    
    func getEventsLiked() -> [EventSwiftData] {
        return events.filter({ $0.like == true })
    }
    
    func loadEvents() async {
        await performOperation {
            let loadedEvents = try await useCase.getAllEvents()
            events = loadedEvents
            print("✅ Loaded \(loadedEvents.count) events")
            print("=== events:")
            dump(events.map({ ev in
                return (ev.idEvent, ev.eventName, ev.like)
            }))
        }
        /*
        do {
            events = try await useCase.getAllEvents()
            print("=== eventsData", events.count, events[0].eventName ?? "", events[0].like)
        } catch {
            print("⚠️ Failed to load events:", error)
        }
         */
    }
    
    func toggleLike(_ event: EventSwiftData) async throws -> EventSwiftData {
        let newEvent = try await useCase.toggleLike(event)
        await loadEvents()
        return newEvent
    }
    
    /*
    func toggleLikeEvent(_ event: EventSwiftData) async -> Bool {
        return await performOperation {
            print("=== toggleLikeEvent:",event.eventName , event.like)
            event.like.toggle()
            try context.save()
            
            print("✅ Toggled like for event: \(event.eventName ?? "Unknown")")
            await loadEvents()
            return true
        } ?? false
        /*
        do {
            event.like = !event.like
            try context.save()
            await loadEvents()
        } catch {
            print("⚠️ Failed to update book:", error)
        }
        */
    }
    */
    
    func addEvent(event: EventSwiftData) async -> Bool {
        return await performOperation {
            try await useCase.createEvent(event: event)
            await loadEvents()
            print("✅ Added event: \(event.eventName ?? "Unknown")")
            return true
        } ?? false
        /*
        do {
            try await useCase.createEvent(event: event)
            await loadEvents()
        } catch {
            print("⚠️ Failed to add event:", error)
        }
        */
    }

    func deleteEvent(_ event: EventSwiftData) async -> Bool {
        return await performOperation {
            try await useCase.removeEvent(event)
            await loadEvents()
            print("✅ Deleted event: \(event.eventName ?? "Unknown")")
            return true
        } ?? false
        /*
        do {
            try await useCase.removeEvent(event)
            await loadEvents()
        } catch {
            print("⚠️ Failed to delete event:", error)
        }
        */
    }
    
    func applyFilter() async {
        await performOperation {
            let filteredEvents = try await useCase.filter(by: searchText, with: sortOption)
            events = filteredEvents
        }
        /*
        do {
            events = try await useCase.filter(by: searchText, with: sortOption)
        } catch {
            print("⚠️ Filter failed:", error)
        }
        */
    }
    
    func getEvent(by idEvent: String?, or eventName: String?) async -> EventSwiftData? {
        return await useCase.getEvent(by: idEvent, or: eventName)
    }
    
    // MARK: - Private Methods
    
    private func performOperation<T>(_ operation: () async throws -> T) async -> T? {
        isLoading = true
        error = nil
        
        do {
            let result = try await operation()
            isLoading = false
            return result
        } catch {
            self.error = error
            isLoading = false
            print("❌ Operation failed: \(error)")
            return nil
        }
    }
}

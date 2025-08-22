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
        }
    }
    
    func setLike(_ event: Event) async throws -> Event {
        
        let isEventExists = await getEvent(by: event.idEvent, or: event.eventName)
        
        if let  eventData = isEventExists {
            
            
            
            let eventDataUpdate = try await toggleLike(eventData)
            var newEvent = event
            newEvent.like = eventDataUpdate.like
            
            if let index = events.firstIndex(where: { $0.idEvent == eventData.idEvent }) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    events[index].like = newEvent.like
                }
                
            }
            
            return newEvent
        } else {
            var newEvent = event
            newEvent.like = true
            
            // Add to local state immediately
            let newEventSwiftData = newEvent.toEventSwiftData(with: .idle)
            withAnimation(.easeInOut(duration: 0.3)) {
                events.append(newEventSwiftData)
            }
            
            do {
                _ = await addEvent(event: newEventSwiftData)
                return newEvent
            } catch {
                // Remove from local state on error
                withAnimation(.easeInOut(duration: 0.3)) {
                    events.removeAll { $0.idEvent == newEvent.idEvent }
                }
                throw error
            }
            
            //_ = await addEvent(event: newEvent.toEventSwiftData(with: .idle))
            //await loadEvents()
            //return newEvent
        }
    }
    
    func toggleLike(_ event: EventSwiftData) async throws -> EventSwiftData {
        let newEvent = try await useCase.toggleLike(event)
        
        return newEvent
    }
    
    func setNotification(_ event: Event, by status: NotificationStatus) async throws -> Bool {
        return await performOperation {
            let isEventSwiftDataExists = await getEvent(by: event.idEvent, or: event.eventName)
            
            guard let eventSwiftData = isEventSwiftDataExists else {
                Task {
                    _ = await addEvent(event: event.toEventSwiftData(with: status))
                    return
                }
                return false }
            
            try await useCase.setNotification(eventSwiftData, by: status)
            return true
        } ?? false
    }
    
    func addEvent(event: EventSwiftData) async -> Bool {
        return await performOperation {
            try await useCase.createEvent(event: event)
            //await loadEvents()
            return true
        } ?? false
    }

    func deleteEvent(_ event: EventSwiftData) async -> Bool {
        return await performOperation {
            try await useCase.removeEvent(event)
            await loadEvents()
            return true
        } ?? false
    }
    
    func applyFilter() async {
        await performOperation {
            let filteredEvents = try await useCase.filter(by: searchText, with: sortOption)
            events = filteredEvents
        }
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

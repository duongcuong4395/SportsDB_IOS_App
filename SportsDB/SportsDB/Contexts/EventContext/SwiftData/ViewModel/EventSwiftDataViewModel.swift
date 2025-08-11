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

@MainActor
class EventSwiftDataViewModel: ObservableObject {
    @Published private(set) var events: [EventSwiftData] = []
    
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .newest
    
    var context: ModelContext
    var useCase: EventSwiftDataUseCaseProtocol
    
    init(context: ModelContext, useCase: EventSwiftDataUseCaseProtocol) {
        self.context = context
        self.useCase = useCase
    }
    
    func loadEvents() async {
        do {
            events = try await useCase.getAllEvents()
            print("=== eventsData", events.count, events[0].eventName ?? "", events[0].like)
        } catch {
            print("⚠️ Failed to load events:", error)
        }
    }

    func toggleLikeEvent(_ event: EventSwiftData) async {
        do {
            event.like = !event.like
            try context.save()
            await loadEvents()
        } catch {
            print("⚠️ Failed to update book:", error)
        }
    }
    
    func toggleNotificationEvent(_ event: EventSwiftData) {
        do {
            event.hasNotification = !event.hasNotification
            try context.save()
        } catch {
            
        }
    }
    
    
    func addEvent(event: EventSwiftData) async {
        do {
            try await useCase.createEvent(event: event)
            await loadEvents()
        } catch {
            print("⚠️ Failed to add event:", error)
        }
    }

    func deleteEvent(_ event: EventSwiftData) async {
        do {
            try await useCase.removeEvent(event)
            await loadEvents()
        } catch {
            print("⚠️ Failed to delete event:", error)
        }
    }
    
    func applyFilter() async {
        do {
            events = try await useCase.filter(by: searchText, with: sortOption)
        } catch {
            print("⚠️ Filter failed:", error)
        }
    }
    
    func isEventExists(idEvent: String?, eventName: String?) -> (isExists: Bool, event: EventSwiftData?) {
        return useCase.isEventExists(idEvent: idEvent, eventName: eventName)
    }
}

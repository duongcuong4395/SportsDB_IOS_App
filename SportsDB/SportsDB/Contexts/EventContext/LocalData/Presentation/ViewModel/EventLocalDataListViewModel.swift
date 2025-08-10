//
//  EventLocalDataListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 8/8/25.
//

import SwiftUI
import SwiftData

enum SortOption {
    case newest, oldest
}

@MainActor
class EventLocalDataListViewModel: ObservableObject {
    @Published private(set) var events: [EventLocalData] = []
    
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .newest
    
    var context: ModelContext
    var useCase: EventLocalDataUseCase
    
    init(context: ModelContext
        , useCase: EventLocalDataUseCase) {
        self.useCase = useCase
        self.context = context
    }
    
    func loadEvents() async {
        do {
            events = try await useCase.getAllEvents()
            print("=== eventsData", events.count, events[0].eventName ?? "", events[0].like)
        } catch {
            print("⚠️ Failed to load events:", error)
        }
    }

    func toggleLikeEvent(_ event: EventLocalData) async {
        do {
            event.like = !event.like
            try context.save()
            await loadEvents()
        } catch {
            print("⚠️ Failed to update book:", error)
        }
    }
    
    func toggleNotificationEvent(_ event: EventLocalData) {
        do {
            event.hasNotification = !event.hasNotification
            try context.save()
        } catch {
            
        }
    }
    
    
    func addEvent(event: EventLocalData) async {
        do {
            try await useCase.createEvent(event: event)
            await loadEvents()
        } catch {
            print("⚠️ Failed to add event:", error)
        }
    }

    func deleteEvent(_ event: EventLocalData) async {
        do {
            try await useCase.removeEvent(event)
            await loadEvents()
        } catch {
            print("⚠️ Failed to delete event:", error)
        }
    }
    
    func applyFilter() async {
        do {
            var descriptor = SortDescriptor(\EventLocalData.eventName, order: .reverse)
            if sortOption == .oldest {
                descriptor = SortDescriptor(\EventLocalData.eventName, order: .forward)
            }

            let predicate: Predicate<EventLocalData> = #Predicate {
                searchText.isEmpty || ($0.eventName ?? "").localizedStandardContains(searchText)
            }

            let fetchDescriptor = FetchDescriptor<EventLocalData>(predicate: predicate, sortBy: [descriptor])
            events = try context.fetch(fetchDescriptor)
        } catch {
            print("⚠️ Filter failed:", error)
        }
    }
    
    func isEventExists(idEvent: String?, eventName: String?) -> (isExists: Bool, event: EventLocalData?) {
        do {
            let predicate: Predicate<EventLocalData> = #Predicate {
                $0.eventName == eventName || $0.idEvent == idEvent
            }
            
            let fetchDescriptor = FetchDescriptor<EventLocalData>(predicate: predicate)
            let res = try context.fetch(fetchDescriptor)
            return (res.count > 0 , res.count > 0 ? res[0] : nil)
        } catch {
            return (false, nil)
        }
        
    }
}

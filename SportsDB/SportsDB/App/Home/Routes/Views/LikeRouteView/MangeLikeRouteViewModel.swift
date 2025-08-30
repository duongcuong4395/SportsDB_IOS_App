//
//  MangeLikeRouteViewModel.swift
//  SportsDB
//
//  Created by Macbook on 30/8/25.
//

import SwiftUI

@MainActor
class ManageLikeRouteViewModel: ObservableObject {
    private let sportRouter: SportRouter
    var eventSwiftDataVM: EventSwiftDataViewModel
    private let eventToggleLikeManager: EventToggleLikeManager
    
    @Published var events: [EventSwiftData] = []
    @Published var searchText: String = ""
    @Published var showingDeleteAlert: Bool = false
    @Published var eventToDelete: EventSwiftData?
    @Published var isSelectionMode: Bool = false
    @Published var selectedEvents: Set<String> = []
    
    var filteredEvents: [EventSwiftData] {
        if searchText.isEmpty {
            return events
        } else {
            return events.filter { event in
                (event.eventName?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (event.leagueName?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    init(sportRouter: SportRouter, eventSwiftDataVM: EventSwiftDataViewModel, eventToggleLikeManager: EventToggleLikeManager) {
        self.sportRouter = sportRouter
        self.eventSwiftDataVM = eventSwiftDataVM
        self.eventToggleLikeManager = eventToggleLikeManager
    }
}

extension ManageLikeRouteViewModel {
    func deleteEvents(at offsets: IndexSet) {
        let eventsToDelete = offsets.map { filteredEvents[$0] }
        
        for event in eventsToDelete {
            handleToggleLike(event)
        }
    }
    
    
    
    func shareEvent(_ event: EventSwiftData) {
        // Implement share functionality
        guard let eventName = event.eventName else { return }
        
        let shareText = "Check out this match: \(eventName)"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    func handleEventTap(_ event: EventSwiftData) {
        // Add your navigation logic here
        // For example: navigate to event detail
        print("Tapped on event: \(event.eventName ?? "")")
    }
    
    func toggleSelection(for event: EventSwiftData) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if let eventId = event.idEvent {
                if selectedEvents.contains(eventId) {
                    selectedEvents.remove(eventId)
                } else {
                    selectedEvents.insert(eventId)
                }
            }
        }
    }
    
    func showDeleteConfirmation(for event: EventSwiftData) {
        eventToDelete = event
        showingDeleteAlert = true
    }
    
    func removeSelectedEvents() {
       let eventsToRemove = events.filter { event in
           selectedEvents.contains(event.idEvent ?? "")
       }
       
       guard !eventsToRemove.isEmpty else { return }
       
       // Add haptic feedback
       let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
       impactFeedback.impactOccurred()
       
       // Update UI immediately
       withAnimation(.easeInOut(duration: 0.4)) {
           events.removeAll { event in
               selectedEvents.contains(event.idEvent ?? "")
           }
           isSelectionMode = false
           selectedEvents.removeAll()
       }
       
       // Handle batch toggle like operation
       Task {
           await handleBatchToggleLike(eventsToRemove)
       }
   }
    
    func handleBatchToggleLike(_ events: [EventSwiftData]) async {
        do {
            for event in events {
                _ = try await eventSwiftDataVM.toggleLike(event)
                eventToggleLikeManager.toggleLikeOnUI(at: event.idEvent ?? "", by: false)
            }
        } catch {
            print("❌ Failed to batch toggle like: \(error)")
            // Reload events if batch operation fails
            DispatchQueue.main.async {
                self.loadLikedEvents()
            }
        }
    }
    
    /*
    func loadLikedEvents() {
        withAnimation(.easeInOut(duration: 0.3)) {
            events = eventSwiftDataVM.events.filter { $0.like == true }
        }
    }
    */
}

extension ManageLikeRouteViewModel {
    func loadLikedEvents() {
        withAnimation(.easeInOut(duration: 0.3)) {
            events = eventSwiftDataVM.events.filter { $0.like == true }
        }
    }
    
    func handleToggleLike(_ event: EventSwiftData) {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        Task {
            do {
                _ = try await eventSwiftDataVM.toggleLike(event)
                
                // Remove from local list with animation
                withAnimation(.easeInOut(duration: 0.4)) {
                    events.removeAll(where: { $0.idEvent == event.idEvent })
                }
                
                // Update the toggle manager
                eventToggleLikeManager.toggleLikeOnUI(at: event.idEvent ?? "", by: false)
                
            } catch {
                print("❌ Failed to toggle like: \(error)")
                // You might want to show an error message here
            }
        }
    }
    
    /*
    func handleToggleLike(_ event: EventSwiftData) {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        Task {
            do {
                _ = try await eventSwiftDataVM.toggleLike(event)
                
                // Remove from local list with animation
                withAnimation(.easeInOut(duration: 0.4)) {
                    events.removeAll(where: { $0.idEvent == event.idEvent })
                }
                
                // Update the toggle manager
                eventToggleLikeManager.toggleLikeOnUI(at: event.idEvent ?? "", by: false)
                
            } catch {
                print("❌ Failed to toggle like: \(error)")
                // You might want to show an error message here
            }
        }
    }
    */
}

extension ManageLikeRouteViewModel {
    func resetEventsSelected() {
        selectedEvents.removeAll()
    }
    
    func resetSelectionMode() {
        isSelectionMode = false
    }
    
    func toggleSelectionMode() {
        isSelectionMode.toggle()
    }
}

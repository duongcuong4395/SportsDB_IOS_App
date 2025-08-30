//
//  ManageNotificationRouteViewModel.swift
//  SportsDB
//
//  Created by Macbook on 30/8/25.
//

import SwiftUI

@MainActor
class ManageNotificationRouteViewModel: ObservableObject {
    private let notificationListVM: NotificationListViewModel
    private let sportRouter: SportRouter
    private let eventSwiftDataVM: EventSwiftDataViewModel
    private let eventToggleNotificationManager: EventToggleNotificationManager
    
    @Published var notifications: [NotificationItem] = []
    @Published var searchText: String = ""
    @Published var showingDeleteAlert: Bool = false
    @Published var notifyToDelete: NotificationItem?
    @Published var isSelectionMode: Bool = false
    @Published var selectedNotify: Set<String> = []
    
    @Published var isLoading: Bool = false
    
    var filteredNotification: [NotificationItem] {
        if searchText.isEmpty {
            return notifications
        } else {
            return notifications.filter { event in
                (event.title.localizedCaseInsensitiveContains(searchText)) ||
                (event.body.localizedCaseInsensitiveContains(searchText))
            }
        }
    }
    
    
    
    init(notificationListVM: NotificationListViewModel, sportRouter: SportRouter, eventSwiftDataVM: EventSwiftDataViewModel, eventToggleNotificationManager: EventToggleNotificationManager) {
        self.notificationListVM = notificationListVM
        self.sportRouter = sportRouter
        self.eventSwiftDataVM = eventSwiftDataVM
        self.eventToggleNotificationManager = eventToggleNotificationManager
    }
}

extension ManageNotificationRouteViewModel {
    func loadNotifySaved() {
        self.isLoading = true
        
        Task {
            await notificationListVM.loadNotifications()
            withAnimation(.easeInOut(duration: 0.3)) {
                
                notifications = notificationListVM.notifications
                self.isLoading = false
            }
        }
    }
    
    func handleToggleNotification(_ notify: NotificationItem) {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        Task {
            await notificationListVM.removeNotification(id: notify.id)
            await notificationListVM.loadNotifications()
            // Remove from local list with animation
            withAnimation(.easeInOut(duration: 0.4)) {
                notifications.removeAll(where: { $0.id == notify.id })
            }
            eventToggleNotificationManager.toggleNotificationOnUI(at: notify.userInfo["idEvent"] ?? "", by: .idle)
        }
    }
    
    func deleteEvents(at offsets: IndexSet) {
        let eventsToDelete = offsets.map { filteredNotification[$0] }
        
        for event in eventsToDelete {
            handleToggleNotification(event)
        }
    }
    
    func toggleSelection(for event: NotificationItem) {
        withAnimation(.easeInOut(duration: 0.2)) {
            let eventId = event.id
            if selectedNotify.contains(eventId) {
                selectedNotify.remove(eventId)
            } else {
                selectedNotify.insert(eventId)
            }
        }
    }
    
    func showDeleteConfirmation(for event: NotificationItem) {
        notifyToDelete = event
        showingDeleteAlert = true
    }
    
    func shareEvent(_ event: NotificationItem) {
        // Implement share functionality
        let eventName = event.title
        
        let shareText = "Check out this match: \(eventName)"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    func handleEventTap(_ event: NotificationItem) {
        // Add your navigation logic here
        // For example: navigate to event detail
        print("Tapped on event: \(event.title)")
    }
    
    func removeSelectedNotify() {
        let eventsToRemove = notifications.filter { event in
            selectedNotify.contains(event.id)
       }
       
       guard !eventsToRemove.isEmpty else { return }
       
       // Add haptic feedback
       let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
       impactFeedback.impactOccurred()
       
       // Update UI immediately
       withAnimation(.easeInOut(duration: 0.4)) {
           notifications.removeAll { event in
               selectedNotify.contains(event.id)
           }
           isSelectionMode = false
           selectedNotify.removeAll()
       }
       
       // Handle batch toggle like operation
       Task {
           await handleBatchToggleNotify(eventsToRemove)
       }
   }
    
    // New batch toggle like method
    private func handleBatchToggleNotify(_ events: [NotificationItem]) async {
        do {
            for notify in events {
                await notificationListVM.removeNotification(id: notify.id)
                await notificationListVM.loadNotifications()
                
                eventToggleNotificationManager.toggleNotificationOnUI(at: notify.userInfo["idEvent"] ?? "", by: .idle)
            }
        } catch {
            print("❌ Failed to batch toggle like: \(error)")
            // Reload events if batch operation fails
            DispatchQueue.main.async {
                //self.loadLikedEvents()
            }
        }
    }
}

extension ManageNotificationRouteViewModel {
    func toggleSelectionMode() {
        isSelectionMode.toggle()
    }
    
    func resetNotifySelected() {
        selectedNotify.removeAll()
    }
    
    
}

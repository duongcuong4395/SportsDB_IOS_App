//
//  NotificationListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import SwiftUI

// MARK: - Error Types
enum NotificationError: Error, LocalizedError {
    case permissionDenied
    case scheduleFailure
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Notification permission was denied"
        case .scheduleFailure:
            return "Failed to schedule notification"
        }
    }
}

final class NotificationListViewModel: ObservableObject {
    @Published private(set) var notifications: [NotificationItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let notificationManager = NotificationManager.shared
    
    // MARK: - Public Methods
    func loadNotifications() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }
        
        
        do {
            let items = await notificationManager.getPendingNotifications()
            DispatchQueue.main.async {
                withAnimation {
                    self.notifications = items
                }
                
            }
            
            print("✅ Loaded \(items.count) notifications")
        } catch {
            self.error = error
            print("❌ Failed to load notifications: \(error)")
        }
        DispatchQueue.main.async {
            self.isLoading = false
        }
        
        /*
        let items = await NotificationManager.shared.getPendingNotifications()
        DispatchQueue.main.async {
            self.notifications = items
            print("=== notifications", items.count)
        }
         */
    }
    
    func toggleNotification(_ event: Event) async -> Event {
        var newEvent = event
        let notification = await getNotification(for: event.idEvent ?? "")
        guard let notification = notification else {
            guard let noti = event.asNotificationItem else { return newEvent }
            _ = await addNotification(noti)

            newEvent.notificationStatus = .creeated
            return newEvent
        }
        
        await removeNotification(id: notification.id)
        newEvent.notificationStatus = .idle
        return newEvent
    }
    
    func addNotification(_ item: NotificationItem) async -> Bool {
        guard await ensurePermission() else { return false }
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        notificationManager.scheduleNotification(item)
        await loadNotifications()
        return true
        /*
        NotificationManager.shared.scheduleNotification(item)
        await loadNotifications()
         */
    }
    
    func removeNotification(id: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        notificationManager.cancelNotification(id: id)
        await loadNotifications()
        
        /*
        NotificationManager.shared.cancelNotification(id: id)
        
         */
    }
    
    func hasNotification(for eventID: String) -> Bool {
        notifications.contains { $0.userInfo["idEvent"] == eventID }
    }
    
    func getNotification(for eventID: String) async -> NotificationItem? {
        await loadNotificationsIfNeeded()
        return notifications.first { $0.userInfo["idEvent"] == eventID }
        /*
        let isAuthorized = await NotificationManager.shared.checkPermissionStatus()
        if isAuthorized {
            await loadNotifications()
            return notifications.first { $0.userInfo["idEvent"] == eventID }
        } else {
            let hasPermission = await NotificationManager.shared.requestPermission()
            await loadNotifications()
            return notifications.first { $0.userInfo["idEvent"] == eventID }
        }
        */
    }
    
    // MARK: - Private Methods
        
    private func ensurePermission() async -> Bool {
        let isAuthorized = await notificationManager.checkPermissionStatus()
        if isAuthorized {
            return true
        }
        
        let hasPermission = await notificationManager.requestPermission()
        if !hasPermission {
            error = NotificationError.permissionDenied
        }
        return hasPermission
    }
    
    private func loadNotificationsIfNeeded() async {
        if notifications.isEmpty {
            await loadNotifications()
        }
    }
}

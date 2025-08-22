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
    
    @Published var tappedNotification: NotificationItem?
    
    private let notificationManager = NotificationManager.shared
    
    init() {
        // Thiết lập xử lý khi tap notification
        notificationManager.onNotificationTapped = { [weak self] notificationItem in
            DispatchQueue.main.async {
                self?.handleNotificationTap(notificationItem)
            }
        }
    }
    
    // MARK: - Handle Notification Tap
    private func handleNotificationTap(_ notification: NotificationItem) {
        print("🎯 Handling notification tap:")
        print("Event ID: \(notification.userInfo["idEvent"] ?? "N/A")")
        print("League: \(notification.userInfo["leagueName"] ?? "N/A")")
        print("Teams: \(notification.userInfo["homeTeamName"] ?? "N/A") vs \(notification.userInfo["awayTeamName"] ?? "N/A")")
        
        // Lưu notification đã tap để UI có thể sử dụng
        tappedNotification = notification
        
        // Xử lý navigation hoặc action khác tại đây
        navigateToEventDetail(notification)
    }
    
    private func navigateToEventDetail(_ notification: NotificationItem) {
        guard let eventId = notification.userInfo["idEvent"] else { return }
        
        // Ví dụ: Post notification để các view khác có thể lắng nghe
        NotificationCenter.default.post(
            name: NSNotification.Name("NavigateToEvent"),
            object: nil,
            userInfo: [
                "eventId": eventId,
                "notification": notification
            ]
        )
        
        print("📍 Should navigate to event: \(eventId)")
    }
    
    // MARK: - Public Methods
    func loadNotifications() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }

        let items = await notificationManager.getPendingNotifications()
        DispatchQueue.main.async {
            withAnimation {
                self.notifications = items
            }
            self.isLoading = false
        }
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
    }
    
    func removeNotification(id: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        notificationManager.cancelNotification(id: id)
        await loadNotifications()
    }
    
    func hasNotification(for eventID: String) -> Bool {
        notifications.contains { $0.userInfo["idEvent"] == eventID }
    }
    
    func getNotification(for eventID: String) async -> NotificationItem? {
        await loadNotificationsIfNeeded()
        return notifications.first { $0.userInfo["idEvent"] == eventID }
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

//
//  NotificationListViewModel.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import SwiftUI

final class NotificationListViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    
    func loadNotifications() async {
        let items = await NotificationManager.shared.getPendingNotifications()
        DispatchQueue.main.async {
            self.notifications = items
            print("=== notifications", items.count)
        }
    }
    
    func addNotification(_ item: NotificationItem) async {
        NotificationManager.shared.scheduleNotification(item)
        await loadNotifications()
    }
    
    func removeNotification(id: String) async {
        NotificationManager.shared.cancelNotification(id: id)
        await loadNotifications()
    }
    
    func hasNotification(for eventID: String) -> Bool {
        return notifications.contains { $0.userInfo["idEvent"] == eventID }
    }
    
    func getNotification(for eventID: String) async -> NotificationItem? {
        let isAuthorized = await NotificationManager.shared.checkPermissionStatus()
        if isAuthorized {
            await loadNotifications()
            return notifications.first { $0.userInfo["idEvent"] == eventID }
        } else {
            let hasPermission = await NotificationManager.shared.requestPermission()
            await loadNotifications()
            return notifications.first { $0.userInfo["idEvent"] == eventID }
        }
        
    }
}

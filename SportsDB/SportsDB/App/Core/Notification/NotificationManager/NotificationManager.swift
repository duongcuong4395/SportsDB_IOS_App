//
//  NotificationManager.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    var onNotificationTapped: ((NotificationItem) -> Void)?
        
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: - Schedule
    func scheduleNotification(_ item: NotificationItem) {
        let content = UNMutableNotificationContent()
        content.title = item.title
        content.body = item.body
        content.sound = .default
        content.userInfo = item.userInfo
        
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: item.triggerDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Schedule error: \(error)")
            } else {
                // print("✅ Scheduled notification:")
            }
        }
    }
    
    // MARK: - Cancel
    func cancelNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        
    }
    
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: - Request permission
    func requestPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    continuation.resume(returning: granted)
                }
        }
    }

    // MARK: - Check permission status
    func checkPermissionStatus() async -> Bool {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings.authorizationStatus == .authorized)
            }
        }
    }

    // MARK: - Fetch pending notifications
    func getPendingNotifications() async -> [NotificationItem] {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                let items = requests.compactMap { req -> NotificationItem? in
                    guard let trigger = req.trigger as? UNCalendarNotificationTrigger,
                          let triggerDate = trigger.nextTriggerDate() else { return nil }
                    
                    let userInfoStringDict: [String: String] = req.content.userInfo.reduce(into: [:]) { result, pair in
                        if let key = pair.key as? String,
                           let value = pair.value as? String {
                            result[key] = value
                        }
                    }
                    
                    return NotificationItem(
                        id: req.identifier,
                        title: req.content.title,
                        body: req.content.body,
                        triggerDate: triggerDate,
                        userInfo: userInfoStringDict,
                        hasRead: false
                    )
                }
                continuation.resume(returning: items)
            }
        }
    }
    
    // MARK: - Handle notification tap
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        let notificationId = response.notification.request.identifier
        
        let userInfoStringDict: [String: String] = userInfo.reduce(into: [:]) { result, pair in
            if let key = pair.key as? String,
               let value = pair.value as? String {
                result[key] = value
            }
        }
        
        let notificationItem = NotificationItem(
            id: notificationId,
            title: response.notification.request.content.title,
            body: response.notification.request.content.body,
            triggerDate: Date(), // Hoặc parse từ userInfo nếu cần
            userInfo: userInfoStringDict,
            hasRead: true
        )
        
        onNotificationTapped?(notificationItem)
        
        completionHandler()
    }
}

extension Notification.Name {
    static let navigateToEventDetail = Notification.Name("navigateToEventDetail")
    static let didTapNotification = Notification.Name("didTapNotification")
}

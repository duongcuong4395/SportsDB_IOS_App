//
//  NotificationDelegate.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import UserNotifications

/*
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    
    // Gọi khi user tap notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        let infoDict = userInfo.compactMapValues { $0 as? String }
        
        print("📩 Notification tapped with metadata: \(infoDict)")
        
        // Ví dụ lấy idEvent, eventName, sportType
        if let idEvent = infoDict["idEvent"] {
            print("idEvent: \(idEvent)")
        }
        if let sportTypeRaw = infoDict["sportType"],
           let sportType = SportType(rawValue: sportTypeRaw) {
            print("SportType: \(sportType)")
        }
        
        // 👉 Điều hướng tới màn chi tiết, load dữ liệu từ idEvent, ...
        
        completionHandler()
    }
    
    // Gọi khi notification xuất hiện khi app đang foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
*/

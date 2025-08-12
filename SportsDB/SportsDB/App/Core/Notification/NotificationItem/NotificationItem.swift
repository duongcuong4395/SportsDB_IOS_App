//
//  NotificationItem.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import Foundation

struct NotificationItem: Identifiable, Equatable, Codable {
    var id: String                     // Unique ID
    var title: String                  // Title hiển thị
    var body: String                   // Nội dung
    var triggerDate: Date              // Thời gian trigger
    var userInfo: [String: String]     // Metadata tùy ý (ví dụ: idEvent, sportType...)
    var hasRead: Bool
}

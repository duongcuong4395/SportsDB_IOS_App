//
//  NotificationItem.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import Foundation

struct NotificationItem: Identifiable, Equatable, Codable {
    var id: String                     // Unique ID
    var title: String
    var body: String
    var triggerDate: Date
    var userInfo: [String: String]     // Metadata (ex: idEvent, sportType...)
    var hasRead: Bool
}



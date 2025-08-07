//
//  LeagueDetailRouteMenu.swift
//  SportsDB
//
//  Created by Macbook on 6/8/25.
//

import SwiftUI


enum LeagueDetailRouteMenu: String, RouteMenu {
    
    case General
    case Teams
    case Events
    
    var title: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .General:
            return "info.circle.fill"
        case .Teams:
            return "person.3.fill"
        case .Events:
            return "calendar"
        }
    }
    
    var color: Color {
        switch self {
        case .General:
            return .blue
        case .Teams:
            return .blue // .green
        case .Events:
            return .blue // .orange
        }
    }
}

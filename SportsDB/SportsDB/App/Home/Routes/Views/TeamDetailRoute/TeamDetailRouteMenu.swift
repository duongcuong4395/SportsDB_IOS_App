//
//  TeamDetailRouteMenu.swift
//  SportsDB
//
//  Created by Macbook on 5/8/25.
//

import SwiftUI

enum TeamDetailRouteMenu: String, RouteMenu {

    case General
    case Players
    case Events
    case Trophies
    case Equipments
    
    var title: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .General:
            return "info.circle.fill"
        case .Players:
            return "person.3.fill"
        case .Events:
            return "calendar"
        case .Equipments:
            return "line.3.crossed.swirl.circle.fill"
        case .Trophies:
            return "trophy.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .General:
            return .blue
        case .Players:
            return .green
        case .Events:
            return .orange
        case .Equipments:
            return .brown
        case .Trophies:
            return .yellow
        }
    }
}

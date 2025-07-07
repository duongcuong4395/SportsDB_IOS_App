//
//  Equipment.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI
// MARK: - Equipment
struct Equipment: Equatable, Identifiable {
    var id = UUID()
    var idEquipment, idTeam, date, season: String?
    var equipment: String?
    var type: String
    var username: String?
    
}

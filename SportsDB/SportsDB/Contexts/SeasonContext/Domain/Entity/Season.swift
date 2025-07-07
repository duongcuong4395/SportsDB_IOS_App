//
//  Season.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

import SwiftUI

// MARK: - Season
struct Season: Identifiable, Equatable {
    let id = UUID()
    var season: String
    
    mutating func setSeason(by season: Season) {
        self.season = season.season
    }
}


extension Season {
    func isSelected(_ selected: Season?) -> Bool {
        self == selected
    }
}

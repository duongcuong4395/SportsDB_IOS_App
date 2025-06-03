//
//  Trophy.swift
//  SportsDB
//
//  Created by Macbook on 3/6/25.
//

import SwiftUI
struct Trophy: Codable, Identifiable, Hashable {
    var id: UUID? = UUID()
    var title: String
    var years: [String]
    var honourArtworkLink: String
    
    enum CodingKeys: String, CodingKey {
        case title, years, honourArtworkLink
    }
    
    var season : String {
        if years.count == 2 {
            return years[0] + " - " + years[1]
        } else {
            return years[0]
        }
    }
}

// goup by theo title và honourArtworkLink để mỗi item đó có array season
struct TrophyGroup: Codable, Identifiable, Hashable {
    var id: UUID? = UUID()
    var title: String
    var honourArtworkLink: String
    var listSeason: [String]
}


struct TrophyGroupKey: Hashable {
    let title: String
    let honourArtworkLink: String
}

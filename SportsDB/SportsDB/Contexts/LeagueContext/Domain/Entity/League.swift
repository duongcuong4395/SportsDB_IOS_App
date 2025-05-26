//
//  League.swift
//  SportScore
//
//  Created by Macbook on 26/5/25.
//

import Foundation

// LeagueContext/Domain/Entity/League.swift
struct League: Equatable {
    let id: String
    let name: String
    let sport: String
    let country: String
    let badgeURL: URL?
}


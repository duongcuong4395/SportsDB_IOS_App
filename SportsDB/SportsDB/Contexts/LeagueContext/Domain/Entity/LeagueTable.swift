//
//  LeagueTable.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation

// MARK: - Table
struct LeagueTable: Equatable, Identifiable {
    let id = UUID()
    let idStanding, intRank, idTeam, teamName: String?
    let badge: String?
    let idLeague, league, season, form: String
    let description, played, win, loss: String?
    let draw, goalsFor, goalsAgainst, goalDifference: String?
    let points, dateUpdated: String?
}

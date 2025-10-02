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
    
    init(idStanding: String?, intRank: String?, idTeam: String?, teamName: String?, badge: String?, idLeague: String, league: String, season: String, form: String, description: String?, played: String?, win: String?, loss: String?, draw: String?, goalsFor: String?, goalsAgainst: String?, goalDifference: String?, points: String?, dateUpdated: String?) {
        self.idStanding = idStanding
        self.intRank = intRank
        self.idTeam = idTeam
        self.teamName = teamName
        self.badge = badge
        self.idLeague = idLeague
        self.league = league
        self.season = season
        self.form = form
        self.description = description
        self.played = played
        self.win = win
        self.loss = loss
        self.draw = draw
        self.goalsFor = goalsFor
        self.goalsAgainst = goalsAgainst
        self.goalDifference = goalDifference
        self.points = points
        self.dateUpdated = dateUpdated
    }
    
    init() {
        self.idLeague = ""
        self.league = ""
        self.season = ""
        self.form = ""
        
        self.idStanding = nil
        self.intRank = nil
        self.idTeam = nil
        self.teamName = nil
        self.badge = nil
        
        self.description = nil
        self.played = nil
        self.win = nil
        self.loss = nil
        
        self.draw = nil
        self.goalsFor = nil
        self.goalsAgainst = nil
        self.goalDifference = nil
        
        self.points = nil
        self.dateUpdated = nil
    }
}

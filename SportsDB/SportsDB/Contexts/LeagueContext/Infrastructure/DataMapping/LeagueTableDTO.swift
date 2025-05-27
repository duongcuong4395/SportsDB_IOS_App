//
//  LeagueTableDTO.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import Foundation



// MARK: - Table
struct LeagueTableDTO: Codable {
    let idStanding, intRank, idTeam, teamName: String
    let badge: String
    let idLeague, league, season, form: String
    let description, played, win, loss: String
    let draw, goalsFor, goalsAgainst, goalDifference: String
    let points, dateUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case idStanding, idTeam
        case intRank = "intRank"
        case teamName = "strTeam"
        case badge = "strBadge"
        
        case idLeague = "idLeague"
        case league = "strLeague", season = "strSeason", form = "strForm"
        case description = "strDescription", played = "intPlayed", win = "intWin", loss = "intLoss"
        case draw = "intDraw", goalsFor = "intGoalsFor", goalsAgainst = "intGoalsAgainst", goalDifference = "intGoalDifference"
        case points = "intPoints", dateUpdated
    }
    
    func toDomain() -> LeagueTable {
        return LeagueTable(idStanding: idStanding, intRank: intRank, idTeam: idTeam, teamName: teamName, badge: badge, idLeague: idLeague, league: league, season: season, form: form, description: description, played: played, win: win, loss: loss, draw: draw, goalsFor: goalsFor, goalsAgainst: goalsAgainst, goalDifference: goalDifference, points: points, dateUpdated: dateUpdated)
    }
}

//
//  MilestoneDTO.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//

// MARK: - Milestone
struct MilestoneDTO: Codable {
    var id, idPlayer: String
    var player: String
    var idTeam, idMilestone, team: String
    var sport: String
    var milestone: String
    var milestoneLogo: String
    var dateMilestone: String
    
    enum CodingKeys: String, CodingKey {
        case id, idPlayer
        case player = "strPlayer"
        case idTeam, idMilestone, team = "strTeam"
        case sport = "strSport"
        case milestone = "strMilestone"
        case milestoneLogo = "strMilestoneLogo"
        case dateMilestone = "dateMilestone"
    }
    
    func toDomain() -> Milestone {
        Milestone(id: id, idPlayer: idPlayer, player: player, idTeam: idTeam, idMilestone: idMilestone, team: team, sport: sport, milestone: milestone, milestoneLogo: milestoneLogo, dateMilestone: dateMilestone)
    }
}

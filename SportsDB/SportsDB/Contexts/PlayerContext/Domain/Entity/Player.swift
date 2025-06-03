//
//  Player.swift
//  SportsDB
//
//  Created by Macbook on 29/5/25.
//


struct Player: Equatable {
    var idPlayer, idTeam: String?
    var idTeam2, idTeamNational: String?
    var idAPIfootball, idPlayerManager, idWikidata, idTransferMkt: String?
    var idESPN, nationality, player, playerAlternate: String?
    var team, team2, soccerXMLTeamID: String?
    
    var sport: SportType?
    var dateBorn: String?
    var dateDied: String?
    var number, dateSigned, signing, wage: String?
    var outfitter, kit, agent, birthLocation: String?
    var ethnicity, status: String?
    
    var descriptionEN: String?
    var descriptionDE, descriptionFR, descriptionCN, descriptionIT: String?
    var descriptionJP, descriptionRU, descriptionES, descriptionPT: String?
    var descriptionSE, descriptionNL, descriptionHU, descriptionNO: String?
    var descriptionIL, descriptionPL: String?
    var gender, side, position: String?
    var college: String?
    var facebook, website, twitter, instagram: String?
    var youtube, height, weight, intLoved: String?
    var thumb: String?
    var poster: String?
    var cutout, render: String?
    var banner: String?
    var fanart1, fanart2, fanart3, fanart4: String?
    var creativeCommons, locked: String?
    var relevance: String?
    
}


struct PlayersAIResponse: Codable {
    var name: String
}

import SwiftUI



struct MorePlayersView: View {
    var players: [PlayersAIResponse]
    var team: Team
    var body: some View {
        TabView{
            ForEach(self.players, id: \.name) { player in
                PlayerDetailByAIView(playerName: player.name, teamName: team.teamName)
                    
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: UIScreen.main.bounds.height / 2)
    }

    
}

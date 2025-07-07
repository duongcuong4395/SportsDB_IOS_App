//
//  MorePlayersByAIView.swift
//  SportsDB
//
//  Created by Macbook on 4/6/25.
//

import SwiftUI

struct MorePlayersAIView: View {
    var players: [PlayersAIResponse]
    var team: Team
    var body: some View {
        TabView{
            ForEach(self.players, id: \.name) { player in
                PlayerDetailByAIView(playerName: player.name, teamName: team.teamName, plushPlayer: { player in })
                    
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: UIScreen.main.bounds.height / 2)
    }

    
}

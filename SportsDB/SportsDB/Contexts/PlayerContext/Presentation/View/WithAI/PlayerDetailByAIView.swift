//
//  PlayerDetailByAIView.swift
//  SportsDB
//
//  Created by Macbook on 3/6/25.
//

import SwiftUI

struct PlayerDetailByAIView: View {
    @EnvironmentObject var playerVM: PlayerListViewModel
    var playerName: String
    var teamName: String
    @State var player: Player?
    
    var plushPlayer: (Player) -> Void
    
    var body: some View {
        VStack {
            if let player = player {
                
                //PlayerItemView(player: player)
            }
        }
        .onAppear{
            guard player == nil else { return }
            self.player = Player(player: playerName)
            
            Task {
                
                
                let playersSearch = await playerVM.searchPlayers(by: playerName)
                if let playerF = playersSearch.first(where: { $0.team ?? ""  == teamName }) {
                    print("=== playerF", playerF.player ?? "", playerF.idPlayer ?? "")
                    
                    if let id = playerF.idPlayer {
                        let players = await playerVM.lookupPlayer(by: id)
                        if players.count > 0 {
                            self.player = players[0]
                        } else {
                            self.player = Player(player: playerName)
                        }
                    }
                }
            }
        }
    }
}

//
//  PlayerListView.swift
//  SportsDB
//
//  Created by Macbook on 2/6/25.
//

import SwiftUI

struct PlayerListView_Old: View {
    var players: [Player]
    @State var selection: Int = 0
    
    @State private var offset: CGFloat = 0
    @State private var dragging: Bool = false
    
    var refreshPlayer: (Player) -> Void
    
    var body: some View {
        TabView {
            ForEach(players, id: \.player) { player in
                //PlayerItemView(player: player)
                EmptyView()
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .onAppear{
                        if player.idPlayer == nil {
                            refreshPlayer(player)
                        }
                    }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        
        
    }
}

struct AllPlayerOfTeamView: View {
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @State var selection: Int = 0
    
    @State private var offset: CGFloat = 0
    @State private var dragging: Bool = false
    
    var refreshPlayer: (Player) -> Void
    
    var body: some View {
        TabView {
            ForEach(playerListVM.playersByLookUpAllForaTeam, id: \.player) { player in
                //PlayerItemView(player: player)
                EmptyView()
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .onAppear{
                        if player.idPlayer == nil {
                            refreshPlayer(player)
                        }
                    }
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

enum PlayerExecuteStatus {
    case Idle
    case Progressing
    case Success
    case TryAgain
}

struct PlayerListView: View {
    let players: [Player]
    let refreshPlayer: (Player) async -> PlayerExecuteStatus
    let getPlayerDetail: (Player) async -> Player?
    @State private var currentIndex: Int = 0
    
    @State var playerExecuteStatus: PlayerExecuteStatus = .Idle
    
    var animation: Namespace.ID
    
    var body: some View {
        ForEach(Array(players.enumerated()), id: \.element.player) { index, player in
            PlayerItemView(player: player, animation: animation)
                //.frame(width: geometry.size.width * 0.85)
                .frame(width: UIScreen.main.bounds.width)
                .cornerRadius(10)
                .shadow(radius: 5)
                .onTapGesture {
                    Task {
                        await getPlayerDetail(player)
                    }
                }
            
        }
    }
}



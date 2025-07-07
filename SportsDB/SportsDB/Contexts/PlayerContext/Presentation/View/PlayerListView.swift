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
                PlayerItemView(player: player)
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
                PlayerItemView(player: player)
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
    
    @State private var currentIndex: Int = 0
    
    @State var playerExecuteStatus: PlayerExecuteStatus = .Idle
    
    var body: some View {
        VStack {
            // Custom pager instead of TabView for better performance
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(Array(players.enumerated()), id: \.element.player) { index, player in
                            PlayerItemView(player: player)
                                //.frame(width: geometry.size.width * 0.85)
                                .frame(width: UIScreen.main.bounds.width)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .onAppear {
                                    // Only refresh if needed
                                    if player.idPlayer?.isEmpty != false {
                                        playerExecuteStatus = .Progressing
                                        Task {
                                            let res = await refreshPlayer(player)
                                            playerExecuteStatus = res
                                        }
                                        
                                    }
                                }
                                .overlay {
                                    if playerExecuteStatus == .TryAgain {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                
                                                Image(systemName: "circle.hexagonpath")
                                                    .font(.title)
                                                    .padding()
                                                    .onTapGesture {
                                                        Task {
                                                            _ = await refreshPlayer(player)
                                                        }
                                                        
                                                    }
                                            }
                                        }
                                    }
                                    
                                }
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
            }
            
            // Page indicator
            /*
            if players.count > 1 {
                HStack(spacing: 6) {
                    ForEach(0..<players.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.primary : Color.secondary.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.2), value: currentIndex)
                    }
                }
                .padding(.top, 8)
            }
            */
        }
    }
}



//
//  ListPlayerTabOfTeamDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//
import SwiftUI
import Kingfisher

struct ListPlayerTabOfTeamDetailRouteView: View {
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    var columns: [GridItem] = [GridItem(), GridItem()]
    @State var viewPlayerDetail: Bool = false
    @Namespace var animation
    
    var body: some View {
        VStack {
            SmartContainer(hasScroll: true, maxWidth: .grid) {
                SmartGrid(columns: DeviceSize.current.isPad ? 5 : 3, spacing: .medium) {
                    ListPlayerView(players: playerListVM.playersByLookUpAllForaTeam
                                   , animation: animation
                                   , onTappedPlayerSelected: { player in
                        Task {
                            await getPlayerDetail(player: player)
                        }
                    })
                }
            }
            .padding(.top, viewPlayerDetail ? 50 : 0)
        }
        .overlay {
            if viewPlayerDetail {
                if let player = playerListVM.playerDetail {
                    PlayerDetailView(player: player, animation: animation
                        , resetPlayer: {
                            withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0)) {
                                playerListVM.playerDetail = nil
                                viewPlayerDetail.toggle()
                            }
                        })
                    .opacity(viewPlayerDetail ? 1 : 0)
                }
                
            }
        }
        .onDisappear{
            withAnimation {
                playerListVM.playerDetail = nil
                viewPlayerDetail = false
            }
        }
    }
    
    func getPlayerDetail(player: Player) async  -> Player? {
        withAnimation {
            viewPlayerDetail = false
        }
        guard let team = teamDetailVM.teamSelected else { return nil }
        
        let playersSearch = await playerListVM.searchPlayers(by: player.player ?? "")
        if let playerF = playersSearch.first(where: { $0.team ?? ""  == team.teamName }) {
            if let id = playerF.idPlayer {
                let players = await playerListVM.lookupPlayer(by: id)
                withAnimation {
                    self.playerListVM.playerDetail = players.count > 0 ? players[0] : player
                    viewPlayerDetail = true
                }
            }
        } else {
            return nil
        }
        return nil
    }
}

struct ListPlayerView: View {
    var players: [Player]
    var playerSelected: Player?
    var animation: Namespace.ID
    var onTappedPlayerSelected: (Player) -> Void
    
    var body: some View {
        ForEach(Array(players.enumerated()), id: \.element.player) { index, player in
            if player.player != playerSelected?.player {
                PlayerItemView(player: player, animation: animation)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .onTapGesture {
                        onTappedPlayerSelected(player)
                    }
            }
        }
    }
}

struct PlayerDetailView: View {
    var player: Player
    var animation: Namespace.ID
    var resetPlayer: () -> Void
    
    var body: some View {
        VStack {
            PlayerItemView(player: player, hasDetail: true, animation: animation)
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .background{
                    Color.clear
                        .liquidGlass(cornerRadius: 25, intensity: 0.1, tintColor: .white, hasShimmer: false, hasGlow: false)
                }
                .background(.ultraThinMaterial.opacity(0.9), in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                .padding(.top, 15)
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .padding(5)
                        .background{
                            Color.clear
                                .liquidGlass(cornerRadius: 25, intensity: 0.5, tintColor: .white, hasShimmer: false, hasGlow: false)
                        }
                        .background(.ultraThinMaterial.opacity(0.5), in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .onTapGesture {
                            resetPlayer()
                        }
                }
        }
        .padding(.top, 40)
        .padding(.horizontal, 5)
        .overlay(alignment: .topLeading, content: {
            KFImage(URL(string: player.sport == .Motorsport ? player.cutout ?? "" : player.render ?? ""))
                .placeholder { progress in
                    ProgressView()
                }
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 2)
                .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                .padding(.top, 5)
                //.matchedGeometryEffect(id: "player_\(player.player ?? "")", in: animation)
                .onTapGesture {
                    resetPlayer()
                }
        })
    }
}

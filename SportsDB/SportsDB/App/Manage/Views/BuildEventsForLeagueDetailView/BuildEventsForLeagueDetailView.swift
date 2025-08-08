//
//  BuildEventsForLeagueDetailView.swift
//  SportsDB
//
//  Created by Macbook on 6/6/25.
//

import SwiftUI

struct BuildEventsForSpecific : View, SelectTeamDelegate, EventOptionsViewDelegate {
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventListVM: EventListViewModel
    
    @EnvironmentObject var eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    
    @State var numbRetry: Int = 0
    var onRetry: () -> Void
    
    var body: some View {
        switch eventsInSpecificInSeasonVM.eventsStatus {
        case .success(data: _):
            
            ListEventGenericView(
                events: eventsInSpecificInSeasonVM.events
                , itemBuilder: ItemBuilderForEventsOfPastLeague()
                , onEvent: { event in
                    handle(event)
                })
            /*
            ListEventView(
                events: eventsInSpecificInSeasonVM.events,
                optionEventView: getEventOptionsView,
                tapOnTeam: tapOnTeam,
                eventTapped: { event in })
        */
        case .loading:
            ProgressView()
        case .idle:
            EmptyView()
        case .failure(error: _):
            Text("Please return in a few minutes.")
                .font(.caption2.italic())
                .onAppear {
                    numbRetry += 1
                    guard numbRetry <= 3 else { numbRetry = 0 ; return }
                    onRetry()
                }
        }
        
    }
    
    func handle(_ event: ItemEvent<Event>) {
        switch event {
        case .toggleLike(for: let event) :
            print("=== toggle like event:", event.eventName ?? "")
            var newEvent = event
            newEvent.like.toggle()
            eventsInSpecificInSeasonVM.updateItem(from: event, with: newEvent)
        default: return
        }
    }
}






protocol EventOptionsViewDelegate {}
extension EventOptionsViewDelegate {
    @ViewBuilder
    func getEventOptionsView(event: Event) -> some View {
        EventOptionsView(event: event) { action, event in
            switch action {
            case .toggleFavorite:
                print("=== event:toggleFavorite:", event.eventName ?? "")
                event
            case .toggleNotify:
                print("=== event:toggleNotify:", event.eventName ?? "")
            case .openPlayVideo:
                print("=== event:openPlayVideo:", event.eventName ?? "")
            case .viewDetail:
                print("=== event:viewDetail:", event.eventName ?? "")
            case .pushFireBase:
                print("=== event:pushFireBase:", event.eventName ?? "")
            case .selected:
                print("=== event:selected:", event.eventName ?? "")
            case .drawOnMap:
                print("=== event:drawOnMap:", event.eventName ?? "")
            }
        }
    }
}






struct BuildSeasonForLeagueView: View {
    
    @EnvironmentObject var eventListVM: EventListViewModel
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    
    
    @EnvironmentObject var eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    @EnvironmentObject var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    
    var leagueID: String
    
    var body: some View {
        SeasonForLeagueView(
            tappedSeason: { season in
                withAnimation(.spring()) {
                    guard seasonListVM.seasonSelected != season else { return }
                    seasonListVM.setSeason(by: season) { season in
                        guard let season = season else { return }
                        
                        eventListVM.setCurrentRound(by: 1) { round in
                            eventsPerRoundInSeasonVM.getEvents(of: leagueID, per: "\(round)", in: season.season)
                        }
                    }
                    
                    leagueListVM.resetLeaguesTable()
                    
                    Task {
                        await leagueListVM.lookupLeagueTable(
                            leagueID: leagueID,
                            season: seasonListVM.seasonSelected?.season ?? "")
                        
                        
                        await eventsInSpecificInSeasonVM.getEvents(
                            leagueID: leagueID,
                            season: seasonListVM.seasonSelected?.season ?? "")
                    }
                }
                
            })
    }
}




import Kingfisher


struct BuildPlayersForTeamDetailView: View {
    @EnvironmentObject var playerListVM: PlayerListViewModel
    var team: Team
    var progressing: Bool
    var columns: [GridItem] = [GridItem(), GridItem()]
    
    @State var viewPlayerDetail: Bool = false
    @Namespace var animation
    var body: some View {
        
        
        ZStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        ForEach(Array(playerListVM.playersByLookUpAllForaTeam.enumerated()), id: \.element.player) { index, player in
                            if player.player != playerListVM.playerDetail?.player {
                                PlayerItemView(player: player, animation: animation)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .onTapGesture {
                                        Task {
                                            await getPlayerDetail(player: player)
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding()
                .padding(.top, viewPlayerDetail ? 50 : 0)
            }
            
            
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
    
    func getRefreshPlayer(player: Player) async  -> PlayerExecuteStatus {
        let playersSearch = await playerListVM.searchPlayers(by: player.player ?? "")
        if let playerF = playersSearch.first(where: { $0.team ?? ""  == team.teamName }) {
            print("=== playerF", playerF.player ?? "", playerF.idPlayer ?? "")
            
            if let id = playerF.idPlayer {
                let players = await playerListVM.lookupPlayer(by: id)
                if players.count > 0 {
                    guard let index = playerListVM.playersByLookUpAllForaTeam.firstIndex(where: { $0.player == player.player }) else { return .TryAgain}
                    playerListVM.playersByLookUpAllForaTeam[index] = players[0]
                    return PlayerExecuteStatus.Success
                } else {
                    return PlayerExecuteStatus.TryAgain
                }
            }
        } else {
            return PlayerExecuteStatus.TryAgain
        }
        return PlayerExecuteStatus.Success
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
                .matchedGeometryEffect(id: "player_\(player.player ?? "")", in: animation)
                .onTapGesture {
                    resetPlayer()
                }
        })
    }
}

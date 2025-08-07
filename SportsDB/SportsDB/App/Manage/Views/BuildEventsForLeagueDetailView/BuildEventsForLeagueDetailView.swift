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
            ListEventView(
                events: eventsInSpecificInSeasonVM.events,
                optionEventView: getEventOptionsView,
                tapOnTeam: tapOnTeam,
                eventTapped: { event in })
        
        case .loading:
            ProgressView()
        case .idle:
            EmptyView()
        case .failure(error: _):
            Text("Please return in a few minutes")
                .font(.caption2)
                .onAppear {
                    numbRetry += 1
                    guard numbRetry <= 3 else { numbRetry = 0 ; return }
                    onRetry()
                }
        }
        
    }
}



struct BuildEventsForPastLeagueView: View, SelectTeamDelegate, EventOptionsViewDelegate {
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventListVM: EventListViewModel
    
    @EnvironmentObject var eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel
    
    @State var numbRetry: Int = 0
    
    let onRetry: () -> Void
    
    var body: some View {
        
        switch eventsRecentOfLeagueVM.events {
        case .idle:
            EmptyView()
        case .loading:
            Text("Progressing...")
        case .success(data: let models):
            ListEventView(
                events: models,
                optionEventView: getEventOptionsView,
                tapOnTeam: tapOnTeam,
                eventTapped: { event in })
        case .failure(error: let error):
            ErrorStateView(error: error, onRetry: {})
                .onAppear{
                    numbRetry += 1
                    guard numbRetry <= 3 else { return }
                    onRetry()
                }
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







struct BuildPlayersForTeamDetailView: View {
    @EnvironmentObject var playerListVM: PlayerListViewModel
    var team: Team
    var progressing: Bool
    var columns: [GridItem] = [GridItem(), GridItem()]
    
    @State var viewPlayerDetail: Bool = false
    @Namespace var animation
    var body: some View {
        
        
        ZStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(Array(playerListVM.playersByLookUpAllForaTeam.enumerated()), id: \.element.player) { index, player in
                        if player.player != playerListVM.playerDetail?.player {
                            PlayerItemView(player: player, animation: animation)
                                //.frame(width: geometry.size.width * 0.85)
                                .frame(width: UIScreen.main.bounds.width)
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
            
            if viewPlayerDetail {
                VStack {
                    Color.clear
                        //.ignoresSafeArea(.all)
                        //.liquidGlass(intensity: 0.7, cornerRadius: 15)
                        .frostedGlass(blur: 0.3, opacity: 0.3, cornerRadius: 20)
                        //.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .onTapGesture {
                            withAnimation {
                                playerListVM.playerDetail = nil
                                viewPlayerDetail.toggle()
                            }
                        }
                        
                        
                        .overlay {
                            VStack {
                                if let playerDetail = playerListVM.playerDetail {
                                    PlayerDetailView(player: playerDetail, animation: animation)
                                        
                                }
                            }
                            .padding(10)
                            
                            
                        }
                        .overlay(alignment: .topTrailing, content: {
                            Image(systemName: "xmark")
                                .padding(10)
                                //.background(.ultraThinMaterial, in: Circle())
                                .liquidGlass(intensity: 0.7, cornerRadius: 50)
                                .padding(5)
                                .onTapGesture {
                                    withAnimation {
                                        playerListVM.playerDetail = nil
                                        viewPlayerDetail.toggle()
                                    }
                                }
                        })
                        .padding(.horizontal, 10)
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
        
        
        /*
        CarouselView(items: playerListVM.playersByLookUpAllForaTeam.map { player in
            PlayerItemView(player: player)
                .cornerRadius(10)
                .shadow(radius: 5)
                .onAppear{
                    if player.idPlayer == nil {
                        Task {
                            
                            
                            let playersSearch = await playerListVM.searchPlayers(by: player.player ?? "")
                            if let playerF = playersSearch.first(where: { $0.team ?? ""  == team.teamName }) {
                                print("=== playerF", playerF.player ?? "", playerF.idPlayer ?? "")
                                
                                if let id = playerF.idPlayer {
                                    let players = await playerListVM.lookupPlayer(by: id)
                                    if players.count > 0 {
                                        guard let index = playerListVM.playersByLookUpAllForaTeam.firstIndex(where: { $0.player == player.player }) else { return }
                                        playerListVM.playersByLookUpAllForaTeam[index] = players[0]
                                        //self.player = players[0]
                                    } else {
                                        //self.player = Player(player: playerName)
                                    }
                                }
                            }
                        }
                    }
                }
            
        }, spacing: 5,
         cardWidth: UIScreen.main.bounds.width
         , cardHeight: UIScreen.main.bounds.height / 2  - 20)
        */
        /*
        AllPlayerOfTeamView { player in
            Task {
                
                
                let playersSearch = await playerListVM.searchPlayers(by: player.player ?? "")
                if let playerF = playersSearch.first(where: { $0.team ?? ""  == team.teamName }) {
                    print("=== playerF", playerF.player ?? "", playerF.idPlayer ?? "")
                    
                    if let id = playerF.idPlayer {
                        let players = await playerListVM.lookupPlayer(by: id)
                        if players.count > 0 {
                            guard let index = playerListVM.playersByLookUpAllForaTeam.firstIndex(where: { $0.player == player.player }) else { return }
                            playerListVM.playersByLookUpAllForaTeam[index] = players[0]
                            //self.player = players[0]
                        } else {
                            //self.player = Player(player: playerName)
                        }
                    }
                }
            }
        }
        */
    }
    
    func getPlayerDetail(player: Player) async  -> Player? {
        withAnimation {
            viewPlayerDetail = false
        }
        
        let playersSearch = await playerListVM.searchPlayers(by: player.player ?? "")
        if let playerF = playersSearch.first(where: { $0.team ?? ""  == team.teamName }) {
            print("=== playerF", playerF.player ?? "", playerF.idPlayer ?? "")
            
            if let id = playerF.idPlayer {
                let players = await playerListVM.lookupPlayer(by: id)
                withAnimation {
                    self.playerListVM.playerDetail = players.count > 0 ? players[0] : player
                    viewPlayerDetail = true
                }
                if players.count > 0 {
                    guard let index = playerListVM.playersByLookUpAllForaTeam.firstIndex(where: { $0.player == player.player }) else { return nil }
                    //playerListVM.playersByLookUpAllForaTeam[index] = players[0]
                    //self.player = players[0]
                    /*
                    withAnimation {
                        self.playerListVM.playerDetail = players[0]
                        viewPlayerDetail = true
                    }
                    */
                    
                    return players[0]
                } else {
                    //self.player = Player(player: playerName)
                    return nil
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
                    //self.player = players[0]
                    return PlayerExecuteStatus.Success
                } else {
                    //self.player = Player(player: playerName)
                    return PlayerExecuteStatus.TryAgain
                }
            }
        } else {
            return PlayerExecuteStatus.TryAgain
        }
        return PlayerExecuteStatus.Success
    }
}

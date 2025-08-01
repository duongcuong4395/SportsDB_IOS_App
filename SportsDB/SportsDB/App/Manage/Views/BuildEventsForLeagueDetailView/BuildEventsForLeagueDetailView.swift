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
    
    var body: some View {
        switch eventsInSpecificInSeasonVM.eventsStatus {
        case .success(data: _):
            ListEventView(
                events: eventsInSpecificInSeasonVM.events,
                optionEventView: getEventOptionsView,
                tapOnTeam: tapOnTeam,
                eventTapped: { event in })
        case .failure(error: let error):
            ErrorStateView(error: error, onRetry: {})
        case .loading:
            ProgressView()
        case .idle:
            EmptyView()
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
    var body: some View {
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
        
        HStack {
            PlayerListView(players: playerListVM.playersByLookUpAllForaTeam, refreshPlayer: getRefreshPlayer )
            
            if progressing {
                ProgressView()
                    .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
            }
        }
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

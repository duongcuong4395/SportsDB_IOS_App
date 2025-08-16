//
//  LeagueTableForLeagueDetailView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct LeagueTableForLeagueDetailView: View, SelectTeamDelegate {
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventListVM: EventListViewModel
    
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    
    var onRetry: () -> Void
    
    @State var numbRetry: Int = 0
    
    var body: some View {
        switch leagueListVM.leaguesTableStatus {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
        case .success(_):
            LeagueTableView(
                leaguesTable: leagueListVM.leaguesTable
                , showRanks: $leagueListVM.showRanks
                , tappedTeam: { leagueTable in
                    
                    //teamDetailVM.teamSelected = nil
                    //trophyListVM.resetTrophies()
                    //playerListVM.resetPlayersByLookUpAllForaTeam()
                    
                    resetWhenTapTeam()
                    selectTeam(by: leagueTable.teamName ?? "")
                })
        case .failure(_):
            Text("Please return in a few minutes")
                .font(.caption2)
                .onAppear{
                    numbRetry += 1
                    guard numbRetry <= 3 else { numbRetry = 0 ; return }
                    onRetry()
                }
        }
    }
}

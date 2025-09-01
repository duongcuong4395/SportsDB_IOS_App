//
//  LeagueTableForLeagueDetailView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

// , SelectTeamDelegate
struct LeagueTableForLeagueDetailView: View  {
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    @EnvironmentObject var teamSelectionManager: TeamSelectionManager
    
    var onRetry: () -> Void
    @State var numbRetry: Int = 0
    
    var body: some View {
        switch leagueListVM.leaguesTableStatus {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
        case .success:
            leagueTableContent
        case .failure(_):
            errorView
        }
    }
    
    private var leagueTableContent: some View {
        LeagueTableView(
            leaguesTable: leagueListVM.leaguesTable
            , showRanks: $leagueListVM.showRanks
            , tappedTeam: { leagueTable in
                Task {
                    teamSelectionManager.resetTeamData()
                    _ = try await teamSelectionManager.selectTeam(by: leagueTable.teamName ?? "")
                    //resetWhenTapTeam()
                    //try await selectTeam(by: leagueTable.teamName ?? "")
                }
            })
    }
    
    private var errorView: some View {
        Text("Please return in a few minutes")
            .font(.caption2)
            .onAppear{
                numbRetry += 1
                guard numbRetry <= 3 else { numbRetry = 0 ; return }
                onRetry()
            }
    }
}

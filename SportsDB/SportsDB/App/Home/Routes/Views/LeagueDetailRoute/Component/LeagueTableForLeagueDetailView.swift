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
            getExampleView()
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
    
    @ViewBuilder
    func getExampleView() -> some View {
        let rank = getRanksExample()
        VStack {
            ForEach(0 ..< 3) {_ in
                LeagueTableItemView(rank: rank, tappedTeam: { ranks in })
                    .redacted(reason: .placeholder)
                    .backgroundOfItemTouched(color: .clear)
            }
        }
    }
    
}

func getRanksExample() -> LeagueTable {
    if let jsonEventDTOData = eventRankExampleJson.data(using: .utf8) {
        do {
            let decoder = JSONDecoder()
            let eventDTO = try decoder.decode(LeagueTableDTO.self, from: jsonEventDTOData)
            let domainModel = eventDTO.toDomain()
            return domainModel
        } catch {
            print("❌ JSON decode failed: \(error)")
        }
    }
    
    return LeagueTable()
}
 
let eventRankExampleJson = """
 {
             "idStanding": "5746351",
             "intRank": "1",
             "idTeam": "133602",
             "strTeam": "Liverpool",
             "strBadge": "https://r2.thesportsdb.com/images/media/team/badge/kfaher1737969724.png/tiny",
             "idLeague": "4328",
             "strLeague": "English Premier League",
             "strSeason": "2024-2025",
             "strForm": "DLDLW",
             "strDescription": "Champions League",
             "intPlayed": "38",
             "intWin": "25",
             "intLoss": "4",
             "intDraw": "9",
             "intGoalsFor": "86",
             "intGoalsAgainst": "41",
             "intGoalDifference": "45",
             "intPoints": "84",
             "dateUpdated": "2025-06-17 23:00:07"
         }
"""

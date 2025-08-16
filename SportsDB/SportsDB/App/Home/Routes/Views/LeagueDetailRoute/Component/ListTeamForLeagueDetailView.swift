//
//  ListTeamForLeagueDetailView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct ListTeamForLeagueDetailView: View, SelectTeamDelegate {
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventListVM: EventListViewModel
    
    private let badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (60, 60)
    
    let onRetry: () -> Void
    
    var body: some View {
        switch teamListVM.teamsStatus {
        case .idle:
            EmptyView()
        case .loading:
            Text("Loading Teams...")
            ProgressView()
        case .success(_):
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: AppUtility.columns) {
                    TeamListView(
                        teams: teamListVM.teams,
                        badgeImageSizePerTeam: badgeImageSizePerLeague,
                        teamTapped: { team in
                            
                            Task {
                                resetWhenTapTeam()
                                teamDetailVM.setTeam(by: team)
                                try await selectTeam(by: team.teamName)
                            }
                        }
                    )
                }
            }
            
        case .failure(_):
            Text("Please return in a few minutes.")
                .font(.caption2.italic())
                .onAppear{
                    onRetry()
                }
        }
    }
}

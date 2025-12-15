//
//  TeamDetailRouteHeaderView.swift
//  SportsDB
//
//  Created by Macbook on 5/8/25.
//

import SwiftUI
import Kingfisher

struct TeamDetailRouteHeaderView: View {
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                backRoute()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
            })
            if let team = teamDetailVM.teamSelected {
                HStack(spacing: 5) {
                    KFImage(URL(string: team.badge ?? ""))
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                    VStack {
                        Text(team.teamName)
                            .font(.caption.bold())
                        Text(team.formedYear ?? "")
                            .font(.caption)
                    }
                }
            }
            Spacer()
        }
        .themedBackground(.header(height: 70))
    }
    
    func backRoute() {
        eventsOfTeamByScheduleVM.resetAll()
        teamDetailVM.resetAll()
        playerListVM.resetAll()
        trophyListVM.resetAll()
        sportRouter.pop()
    }
}



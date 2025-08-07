//
//  TeamsTabOfLeagueDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct TeamsTabOfLeagueDetailRouteView: View {
    var league: League
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var sportVM: SportViewModel
    @EnvironmentObject var countryListVM: CountryListViewModel
    
    var body: some View {
        ListTeamForLeagueDetailView(onRetry: {
            Task {
                await teamListVM.getListTeams(
                    leagueName: league.leagueName ?? ""
                    , sportName: sportVM.sportSelected.rawValue
                    , countryName: countryListVM.countrySelected?.name ?? "")
            }
        })
        .padding()
    }
}

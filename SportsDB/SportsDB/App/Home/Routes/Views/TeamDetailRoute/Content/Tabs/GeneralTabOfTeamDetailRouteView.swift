//
//  GeneralTabOfTeamDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct GeneralTabOfTeamDetailRouteView: View {
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    var body: some View {
        if let team = teamDetailVM.teamSelected {
            VStack {
                ScrollView(showsIndicators: false) {
                    TeamAdsView(team: team)
                }
            }
            .padding()
        }
        
    }
}

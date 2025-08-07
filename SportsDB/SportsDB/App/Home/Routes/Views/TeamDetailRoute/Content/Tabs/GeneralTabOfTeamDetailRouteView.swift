//
//  GeneralTabOfTeamDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct GeneralTabOfTeamDetailRouteView: View {
    var team: Team
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                TeamAdsView(team: team)
            }
        }
        .padding()
    }
}

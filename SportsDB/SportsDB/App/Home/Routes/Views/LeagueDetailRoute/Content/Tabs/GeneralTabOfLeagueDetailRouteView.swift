//
//  GeneralTabOfLeagueDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct GeneralTabOfLeagueDetailRouteView: View {
    
    var league: League
    var body: some View {
        VStack(spacing: 5) {
            ScrollView(showsIndicators: false) {
                VStack {
                    TitleComponentView(title: "Description")
                    Text(league.descriptionEN ?? "")
                        .font(.caption)
                        .lineLimit(nil)
                        .frame(alignment: .leading)
                    
                    LeaguesAdsView(league: league)
                }
            }
            .padding()
        }
    }
}

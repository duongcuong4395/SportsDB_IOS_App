//
//  TeamListView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

struct TeamListView: View {
    var teams: [Team]
    var badgeImageSizePerTeam: (width: CGFloat, height: CGFloat)
    var teamTapped: (Team) -> Void
    var body: some View {
        ForEach (Array(teams.enumerated()), id: \.element.id) { index, team in
            TeamItemView(team: team, badgeImageSize: badgeImageSizePerTeam)
            .padding(0)
            .rotateOnAppear(angle: -90, duration: 0.5, axis: .x)
            .onTapGesture {
                teamTapped(team)
            }
            
        }
    }
}



//
//  ListPlayerTabOfTeamDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//
import SwiftUI

struct ListPlayerTabOfTeamDetailRouteView: View {
    var team: Team
    var body: some View {
        BuildPlayersForTeamDetailView(team: team, progressing: false)
    }
}

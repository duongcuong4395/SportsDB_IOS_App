//
//  ListEventOfTeamDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct ListEventOfTeamDetailRouteView: View {
    var team: Team
    @Binding var isVisibleViews: (
        forEvents: Bool,
        forEquipment: Bool
    )

    var body: some View {
        BuildEventsOfTeamByScheduleView(team: team)
            .onAppear{
                isVisibleViews.forEvents = true
            }
            .slideInEffect(isVisible: $isVisibleViews.forEvents, delay: 0.5, direction: .leftToRight)
            .padding(.vertical)
    }
}

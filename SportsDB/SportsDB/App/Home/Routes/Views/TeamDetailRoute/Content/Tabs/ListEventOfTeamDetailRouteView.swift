//
//  ListEventOfTeamDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct ListEventOfTeamDetailRouteView: View {
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @Binding var isVisibleViews: (
        forEvents: Bool,
        forEquipment: Bool
    )

    var body: some View {
        VStack {
            TitleComponentView(title: "Up coming")
            EventsGenericView(eventsViewModel: eventsOfTeamByScheduleVM.eventsOfTeamByUpcomingVM
                , onRetry: { })
            
            
            TitleComponentView(title: "Result")
            EventsGenericView(
                eventsViewModel: eventsOfTeamByScheduleVM.eventsOfTeamByResultsVM
                , onRetry: { })
        }
        .onAppear{
            isVisibleViews.forEvents = true
        }
        //.slideInEffect(isVisible: $isVisibleViews.forEvents, delay: 0.5, direction: .leftToRight)
        .padding(.vertical)
        
        /*
        BuildEventsOfTeamByScheduleView(team: team)
            .onAppear{
                isVisibleViews.forEvents = true
            }
            .slideInEffect(isVisible: $isVisibleViews.forEvents, delay: 0.5, direction: .leftToRight)
            .padding(.vertical)
         */
    }
}

//
//  EventsOfTeamByScheduleView.swift
//  SportsDB
//
//  Created by Macbook on 7/6/25.
//

import SwiftUI
import Shimmer

struct EventsOfTeamByScheduleView<OptionEventView: View>: View {
    @EnvironmentObject var eventListVM: EventListViewModel
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    var team: Team
    
    var optionEventView: (Event) -> OptionEventView
    var tapOnTeam: (Event, KindTeam) -> Void
    var eventTapped: (Event) -> Void
    
    var body: some View {
        VStack {
            TitleComponentView(title: "Up coming")
            
            getEventView(by: eventsOfTeamByScheduleVM.eventsForNext)
            //getEventView(by: eventListVM.eventsOfTeamForNext.executeStatus)
            
            TitleComponentView(title: "Result")
            getEventView(by: eventsOfTeamByScheduleVM.eventsForPrevious)
            //getEventView(by: eventListVM.eventsOfTeamForPrevious.executeStatus)
        }
    }
    
    @ViewBuilder
    func getEventView(by executeStatus: ModelsStatus<[Event]>) -> some View {
        switch executeStatus {
        case .success(data: let events):
            if events.count <= 0 {
                Text("None...")
                    .transition(.opacity)
            } else {
                ListEventView(events: events,
                              optionEventView: optionEventView,
                              tapOnTeam: tapOnTeam,
                              eventTapped: eventTapped)
                .transition(.opacity.combined(with: .slide))
                
            }
        case .idle:
            EmptyView()
        case .loading:
            EventLoadingView()
        case .failure(error: _):
            Text("Please return in a few minutes.")
                .font(.caption2.italic())
        }
    }
}

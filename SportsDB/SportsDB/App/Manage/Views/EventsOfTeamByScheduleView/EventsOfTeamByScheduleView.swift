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
        case .Success(model: let events):
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
        case .Idle:
            VStack {
                ForEach((1...5).reversed(), id: \.self) { _ in
                    EventItemView(isVisible: .constant(false),
                                  delay: 0.5,
                                  event: eventListVM.getEventExample(),
                                  optionView: optionEventView,
                                  tapOnTeam: { event, kind in },
                                  eventTapped: { event in })
                    .redacted(reason: .placeholder)
                    .shimmering()
                }
            }
            .transition(.opacity)
            
        case .Progressing:
            VStack {
                ForEach((1...5).reversed(), id: \.self) { _ in
                    EventItemView(isVisible: .constant(false),
                                  delay: 0.5,
                                  event: eventListVM.getEventExample(),
                                  optionView: optionEventView,
                                  tapOnTeam: { event, kind in },
                                  eventTapped: { event in })
                    .redacted(reason: .placeholder)
                    .shimmering()
                }
            }
            .transition(.opacity)
        case .Fail(message: _):
            Text("EventsOfTeamForPrevious fail")
                .transition(.opacity)
        }
    }
}

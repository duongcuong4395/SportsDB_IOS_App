//
//  BuildEventsForEachRoundView.swift
//  SportsDB
//
//  Created by Macbook on 7/6/25.
//

import SwiftUI
import Shimmer

struct BuildEventsForEachRoundInControl: View {
    var leagueID: String
    
    @EnvironmentObject var eventListVM: EventListViewModel
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    
    @EnvironmentObject var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    
    var body: some View {
        PreviousAndNextRounrEventView(
            currentRound: eventListVM.currentRound,
            hasNextRound: eventListVM.hasNextRound,
            nextRoundTapped: {
                withAnimation(.spring()) {
                    eventListVM.setCurrentRound(by: eventListVM.currentRound + 1) { round in
                        eventsPerRoundInSeasonVM.getEvents(of: leagueID, per: "\(round)", in: seasonListVM.seasonSelected?.season ?? "")
                    }
                }
            },
            previousRoundTapped: {
                withAnimation(.spring()) {
                    eventListVM.setCurrentRound(by: eventListVM.currentRound - 1) { round in
                        eventsPerRoundInSeasonVM.getEvents(of: leagueID, per: "\(round)", in: seasonListVM.seasonSelected?.season ?? "")
                    }
                }
                
                
            })
    }
}

struct BuildEventsForEachRoundView: View, SelectTeamDelegate, EventOptionsViewDelegate {
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventListVM: EventListViewModel
    
    @EnvironmentObject var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    
    var body: some View {
        VStack {
            getEventView(by: eventsPerRoundInSeasonVM.events)
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
                              optionEventView: getEventOptionsView,
                              tapOnTeam: tapOnTeam,
                              eventTapped: { event in })
                .transition(.opacity.combined(with: .slide))
                
            }
        case .Idle:
            VStack {
                Text("Event Idle")
                ForEach((1...5).reversed(), id: \.self) { _ in
                    EventItemView(isVisible: .constant(false),
                                  delay: 0.5,
                                  event: eventListVM.getEventExample(),
                                  optionView: getEventOptionsView,
                                  tapOnTeam: { event, kind in },
                                  eventTapped: { event in })
                    .redacted(reason: .placeholder)
                    .shimmering()
                }
            }
            .transition(.opacity)
            
        case .Progressing:
            VStack {
                Text("Event Progressing")
                ForEach((1...5).reversed(), id: \.self) { _ in
                    EventItemView(isVisible: .constant(false),
                                  delay: 0.5,
                                  event: eventListVM.getEventExample(),
                                  optionView: getEventOptionsView,
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

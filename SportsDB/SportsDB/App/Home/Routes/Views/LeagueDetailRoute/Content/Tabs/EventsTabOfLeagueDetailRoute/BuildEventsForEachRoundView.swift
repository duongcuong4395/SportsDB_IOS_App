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

// , SelectTeamDelegate, EventOptionsViewDelegate

/*
struct BuildEventsForEachRoundView: View{
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventListVM: EventListViewModel
    
    @EnvironmentObject var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    
    @State var numbRetry: Int = 0
    var onRetry: () -> Void
    
    var body: some View {
        VStack {
            switch eventsPerRoundInSeasonVM.eventsStatus {
            case .success(data: _):
                if eventsPerRoundInSeasonVM.events.count <= 0 {
                    Text("No events found.")
                        .transition(.opacity)
                } else {
                    ListEventView(events: eventsPerRoundInSeasonVM.events,
                                  optionEventView: getEventOptionsView,
                                  tapOnTeam: tapOnTeam,
                                  eventTapped: { event in })
                    .transition(.opacity.combined(with: .slide))
                }
            case .idle:
                EmptyView()
            case .loading:
                EventLoadingView()
            case .failure(error: _):
                Text("Please return in a few minutes.")
                    .font(.caption2.italic())
                    .onAppear {
                        numbRetry += 1
                        guard numbRetry <= 3 else { numbRetry = 0 ; return }
                        onRetry()
                    }
            }
        }
    }
}
*/

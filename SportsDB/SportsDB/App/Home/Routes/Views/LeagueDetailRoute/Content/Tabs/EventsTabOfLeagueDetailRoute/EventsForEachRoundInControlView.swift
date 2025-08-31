//
//  EventsForEachRoundInControlView.swift
//  SportsDB
//
//  Created by Macbook on 31/8/25.
//

import SwiftUI

// MARK: BuildEventsForEachRoundInControl
struct EventsForEachRoundInControlView: View {
    var leagueID: String
    
    @EnvironmentObject var eventListVM: EventListViewModel
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    
    @EnvironmentObject var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    
    var body: some View {
        PreviousAndNextRounrEventView(
            currentRound: eventListVM.currentRound,
            hasNextRound: eventListVM.hasNextRound,
            nextRoundTapped: nextRound,
            previousRoundTapped: previousRound)
    }
    
    func previousRound() {
        withAnimation(.spring()) {
            eventListVM.setCurrentRound(by: eventListVM.currentRound - 1) { round in
                eventsPerRoundInSeasonVM.getEvents(of: leagueID, per: "\(round)", in: seasonListVM.seasonSelected?.season ?? "")
            }
        }
    }
    
    func nextRound() {
        withAnimation(.spring()) {
            eventListVM.setCurrentRound(by: eventListVM.currentRound + 1) { round in
                eventsPerRoundInSeasonVM.getEvents(of: leagueID, per: "\(round)", in: seasonListVM.seasonSelected?.season ?? "")
            }
        }
    }
}

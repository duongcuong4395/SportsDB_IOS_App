//
//  SeasonOfLeagueContentView.swift
//  SportsDB
//
//  Created by Macbook on 31/8/25.
//

import SwiftUI

enum SeasonOfLeagueMenu: String, CaseIterable {
    case TableRanking = "Ranking"
    case EventsPerRound = "Events Per Round"
    case AllEventsForASeason = "All Events"
}

extension SeasonOfLeagueMenu: RouteMenu {
    var title: String {
        self.rawValue
    }
    
    var icon: String {
        switch self {
        case .TableRanking: "medal"
        case .EventsPerRound: "list.star"
        case .AllEventsForASeason: "list.star"
        }
    }
    
    var color: Color {
        .blue
    }
    
    func getIconView() -> AnyView {
        AnyView(
            ZStack {
                switch self {
                    case .TableRanking:
                        Image(systemName: "medal")
                            //.font(.title3)
                    case .EventsPerRound:
                        Image(systemName: "list.star")
                            //.font(.title3)
                            .offset(y: 5)
                        Text("Round")
                            .font(.system(size: 10))
                            .offset(x: 5, y: -10)
                    case .AllEventsForASeason:
                        Image(systemName: "list.star")
                            //.font(.title3)
                            .offset(y: 5)
                        Text("All")
                            .font(.system(size: 10))
                            .offset(y: -10)
                }
            }
            
        )
    }
    
    @ViewBuilder
    func getView(by league: League, and season: Season) -> some View {
        switch self {
        case .TableRanking:
            TableRankingView(league: league)
        case .EventsPerRound:
            EventsPerRoundView(league: league)
        case .AllEventsForASeason:
            AllEventsForASeasonView()
        }
    }
}

struct TableRankingView: View {
    @EnvironmentObject private var seasonListVM: SeasonListViewModel
    @EnvironmentObject private var leagueListVM: LeagueListViewModel
    var league: League
    
    init(league: League?) {
        self.league = league ?? League()
    }
    
    var body: some View {
        
        LeagueTableForLeagueDetailView(onRetry: {
            Task {
                guard let season = seasonListVM.seasonSelected else { return }
                await leagueListVM.lookupLeagueTable(
                    leagueID: league.idLeague ?? "",
                    season: season.season)
            }
        })
    }
}

struct EventsPerRoundView: View {
    
    @EnvironmentObject private var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    @EnvironmentObject var eventListVM: EventListViewModel
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    var league: League

    var body: some View {
        VStack {
            EventsForEachRoundView
            EventsGenericView(eventsViewModel: eventsPerRoundInSeasonVM, onRetry: { })
        }
    }
    
    var EventsForEachRoundView: some View {
        PreviousAndNextRounrEventView(
            currentRound: eventListVM.currentRound,
            hasNextRound: eventListVM.hasNextRound,
            nextRoundTapped: nextRound,
            previousRoundTapped: previousRound)
    }
    
    func previousRound() {
        withAnimation(.spring()) {
            eventListVM.setCurrentRound(by: eventListVM.currentRound - 1) { round in
                eventsPerRoundInSeasonVM.getEvents(of: league.idLeague ?? "", per: "\(round)", in: seasonListVM.seasonSelected?.season ?? "")
            }
        }
    }
    
    func nextRound() {
        withAnimation(.spring()) {
            eventListVM.setCurrentRound(by: eventListVM.currentRound + 1) { round in
                eventsPerRoundInSeasonVM.getEvents(of: league.idLeague ?? "", per: "\(round)", in: seasonListVM.seasonSelected?.season ?? "")
            }
        }
    }
}

struct AllEventsForASeasonView: View {
    @EnvironmentObject private var eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    
    var body: some View {
        VStack {
            EventsGenericView(eventsViewModel: eventsInSpecificInSeasonVM, onRetry: { })
        }
    }
}

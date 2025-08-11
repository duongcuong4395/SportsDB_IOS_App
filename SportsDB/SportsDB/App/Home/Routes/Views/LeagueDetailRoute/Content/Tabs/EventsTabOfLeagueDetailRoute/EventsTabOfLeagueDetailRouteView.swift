//
//  EventsTabOfLeagueDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct EventsTabOfLeagueDetailRouteView: View {
    var league: League
    
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    
    // MARK: ViewModel for event
    @EnvironmentObject var eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel
    @EnvironmentObject var eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    @EnvironmentObject var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack{
                    TitleComponentView(title: "Recent Events")
                    EventsGenericView(eventsViewModel: eventsRecentOfLeagueVM, onRetry: {
                        eventsRecentOfLeagueVM.getEvents(by: league.idLeague ?? "")
                    })
                    
                    TitleComponentView(title: "Seasons")
                    BuildSeasonForLeagueView(leagueID: league.idLeague ?? "")

                    if seasonListVM.seasonSelected == nil {
                        Text("Select season to see more about table rank and round events.")
                            .font(.caption2)
                    }
                    
                    if seasonListVM.seasonSelected != nil {
                        TitleComponentView(title: "Ranks")
                        LeagueTableForLeagueDetailView(onRetry: {
                            Task {
                                guard let season = seasonListVM.seasonSelected else { return }
                                await leagueListVM.lookupLeagueTable(
                                    leagueID: league.idLeague ?? "",
                                    season: season.season)
                            }
                        })
                        .frame(maxHeight: UIScreen.main.bounds.height / 2.5)

                        TitleComponentView(title: "Events")
                        BuildEventsForEachRoundInControl(leagueID: league.idLeague ?? "")
                        
                        EventsGenericView(eventsViewModel: eventsPerRoundInSeasonVM, onRetry: { })
                            .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                        
                        TitleComponentView(title: "Events Specific")
                        EventsGenericView(eventsViewModel: eventsInSpecificInSeasonVM, onRetry: { })
                            .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                    }
                }
            }
            .padding(.vertical)
            
        }
    }
}

// MARK: BuildSeasonForLeagueView
struct BuildSeasonForLeagueView: View {
    
    @EnvironmentObject var eventListVM: EventListViewModel
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    
    @EnvironmentObject var eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    @EnvironmentObject var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    
    let leagueID: String
    
    var body: some View {
        SeasonForLeagueView(
            tappedSeason: { season in
                withAnimation(.spring()) {
                    guard seasonListVM.seasonSelected != season else { return }
                    seasonListVM.setSeason(by: season) { season in
                        guard let season = season else { return }
                        
                        eventListVM.setCurrentRound(by: 1) { round in
                            eventsPerRoundInSeasonVM.getEvents(of: leagueID, per: "\(round)", in: season.season)
                        }
                    }
                    
                    leagueListVM.resetLeaguesTable()
                    
                    Task {
                        await leagueListVM.lookupLeagueTable(
                            leagueID: leagueID,
                            season: seasonListVM.seasonSelected?.season ?? "")
                        
                        
                        await eventsInSpecificInSeasonVM.getEvents(
                            leagueID: leagueID,
                            season: seasonListVM.seasonSelected?.season ?? "")
                    }
                }
                
            })
    }
}

// MARK: BuildEventsForEachRoundInControl
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

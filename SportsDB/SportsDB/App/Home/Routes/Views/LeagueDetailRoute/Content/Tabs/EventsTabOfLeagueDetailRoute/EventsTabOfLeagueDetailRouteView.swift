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
                    /*
                    BuildEventsForPastLeagueView(onRetry: {
                        eventsRecentOfLeagueVM.getEvents(by: league.idLeague ?? "")
                    })
                     */
                    
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
                        //BuildEventsForEachRoundView(onRetry: {  })
                            .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                        
                        TitleComponentView(title: "Events Specific")
                        EventsGenericView(eventsViewModel: eventsInSpecificInSeasonVM, onRetry: { })
                        //BuildEventsForSpecific(onRetry: {  })
                            .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                    }
                }
            }
            .padding(.vertical)
            
        }
    }
}

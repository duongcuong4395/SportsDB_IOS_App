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
                    
                    HStack {
                        Text("Seasons:")
                            .font(.callout.bold())
                        ListSeasonForLeagueView(leagueID: league.idLeague ?? "")
                    }

                    if seasonListVM.seasonSelected == nil {
                        Text("Select season to see more about table rank and round events.")
                            .font(.caption2)
                    } else { // if seasonListVM.seasonSelected != nil
                        SeasonOfLeagueContentView(league: league)
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 5)
        }
    }
    
    
}





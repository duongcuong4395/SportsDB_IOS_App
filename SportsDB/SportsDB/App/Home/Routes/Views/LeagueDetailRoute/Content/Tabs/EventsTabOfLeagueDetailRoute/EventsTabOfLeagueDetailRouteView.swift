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
                        BuildSeasonForLeagueView(leagueID: league.idLeague ?? "")
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
                selectSeason(season)
            })
    }
    
    func selectSeason(_ season: Season) {
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
    }
}



//
//  buildSeasonForLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 7/6/25.
//

import SwiftUI

struct buildSeasonForLeagueView: View {
    @EnvironmentObject var eventListVM: EventListViewModel
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    
    @EnvironmentObject var eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    
    @EnvironmentObject var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    
    
    let leagueID: String
    
    var body: some View {
        SeasonForLeagueView(
            tappedSeason: { season in
                withAnimation(.spring()) {
                    leagueListVM.resetLeaguesTable()
                    
                    seasonListVM.setSeason(by: season) { season in
                        guard let season = season else { return }
                        
                        eventListVM.setCurrentRound(by: 1) { round in
                            eventsPerRoundInSeasonVM.getEvents(of: leagueID, per: "\(round)", in: season.season)
                        }
                    }
                    
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

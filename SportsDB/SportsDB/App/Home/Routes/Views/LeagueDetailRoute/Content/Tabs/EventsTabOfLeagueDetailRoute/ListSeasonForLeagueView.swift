//
//  ListSeasonForLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 31/8/25.
//

import SwiftUI

// MARK: BuildSeasonForLeagueView
struct ListSeasonForLeagueView: View {
    
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
        guard seasonListVM.seasonSelected != season else { return }
        
        Task {
            let season = await seasonListVM.setSeason(by: season)
            guard let season = season else { return }
            
            let round = await eventListVM.setCurrentRound(by: 1)
            
            await leagueListVM.lookupLeagueTable(
                leagueID: leagueID,
                season: season.season)
            
            await eventsInSpecificInSeasonVM.getEvents(
                leagueID: leagueID,
                season: seasonListVM.seasonSelected?.season ?? "")
            
            eventsPerRoundInSeasonVM.getEvents(of: leagueID, per: "\(round)", in: season.season)
        }
        
        //withAnimation(.spring()) {}
        
        /*
        guard seasonListVM.seasonSelected != season else { return }
        
        
         seasonListVM.setSeason(by: season) { season in
             guard let season = season else { return }
             
             eventListVM.setCurrentRound(by: 1) { round in
                 eventsPerRoundInSeasonVM.getEvents(of: leagueID, per: "\(round)", in: season.season)
             }
         }
        
        
        
        
        leagueListVM.resetLeaguesTable()
        
        await leagueListVM.lookupLeagueTable(
            leagueID: leagueID,
            season: seasonListVM.seasonSelected?.season ?? "")
        
        
        await eventsInSpecificInSeasonVM.getEvents(
            leagueID: leagueID,
            season: seasonListVM.seasonSelected?.season ?? "")
        */
    }
}

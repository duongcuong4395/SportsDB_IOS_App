//
//  ListSeasonForLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 31/8/25.
//

import SwiftUI

class ListSeasonForLeagueViewModel: ObservableObject {
    private var eventListVM: EventListViewModel
    private var leagueListVM: LeagueListViewModel
    private var seasonListVM: SeasonListViewModel
    
    private var eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    private var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    
    init(eventListVM: EventListViewModel, leagueListVM: LeagueListViewModel, seasonListVM: SeasonListViewModel, eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel, eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel) {
        self.eventListVM = eventListVM
        self.leagueListVM = leagueListVM
        self.seasonListVM = seasonListVM
        self.eventsInSpecificInSeasonVM = eventsInSpecificInSeasonVM
        self.eventsPerRoundInSeasonVM = eventsPerRoundInSeasonVM
    }
    
    @MainActor func selectSeason(_ season: Season, in league: String) {
        guard seasonListVM.seasonSelected != season else { return }
        
        Task {
            let season = await seasonListVM.setSeason(by: season)
            guard let season = season else { return }
            
            let round = await eventListVM.setCurrentRound(by: 1)
            
            leagueListVM.resetLeaguesTable()
            
            await leagueListVM.lookupLeagueTable(
                leagueID: league,
                season: season.season)
            
            await eventsInSpecificInSeasonVM.getEvents(
                leagueID: league,
                season: seasonListVM.seasonSelected?.season ?? "")
            
            eventsPerRoundInSeasonVM.getEvents(of: league, per: "\(round)", in: season.season)
        }
    }
    
}

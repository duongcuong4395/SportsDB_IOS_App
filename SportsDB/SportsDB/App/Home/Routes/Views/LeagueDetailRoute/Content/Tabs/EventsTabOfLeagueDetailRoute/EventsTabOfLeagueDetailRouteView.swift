//
//  EventsTabOfLeagueDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

enum MenuOfEventsAtTabOfLeagueDetailRouteView: String, CaseIterable {
    case TableRanking = "Table Ranking"
    case EventsPerRound = "Events Per Round"
    case AllEventsForASeason = "All events in a season"
}

extension MenuOfEventsAtTabOfLeagueDetailRouteView {
    
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
    
    init(league: League) {
        self.league = league
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
    
    var league: League
    init(league: League) {
        self.league = league
    }
    
    var body: some View {
        VStack {
            BuildEventsForEachRoundInControl(leagueID: league.idLeague ?? "")
            
            EventsGenericView(eventsViewModel: eventsPerRoundInSeasonVM, onRetry: { })
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


struct EventsTabOfLeagueDetailRouteView: View {
    var league: League
    
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    
    // MARK: ViewModel for event
    @EnvironmentObject var eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel
    @EnvironmentObject var eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    @EnvironmentObject var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    
    @State var menuOfEventActive: MenuOfEventsAtTabOfLeagueDetailRouteView = .TableRanking
    
    @Namespace var animation
    
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
                        MenuOfEventsView
                        
                        menuOfEventActive.getView(by: league, and: seasonListVM.seasonSelected ?? Season(season: ""))
                            .frame(maxHeight: UIScreen.main.bounds.height / 2.75)
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 5)
        }
    }
    
    @ViewBuilder
    var MenuOfEventsView: some View {
        HStack(spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(MenuOfEventsAtTabOfLeagueDetailRouteView.allCases, id: \.self) { menu in
                        Text(menu.rawValue)
                            .font(menuOfEventActive.rawValue == menu.rawValue ? .callout.bold() : .callout)
                            .padding(5)
                            .background{
                                if menuOfEventActive == menu {
                                    Color.clear
                                        .background(.thinMaterial.opacity( menuOfEventActive.rawValue == menu.rawValue  ? 1 : 0)
                                                , in: RoundedRectangle(cornerRadius: 25))
                                        .matchedGeometryEffect(id: "menuOfEvents", in: animation)
                                }
                                
                            }
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    menuOfEventActive = menu
                                }
                            }
                        
                    }
                }
                
            }
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

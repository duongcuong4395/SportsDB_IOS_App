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

struct SeasonOfLeagueContentView: View {
    var league: League
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    @State var menuOfEventActive: SeasonOfLeagueMenu = .TableRanking
    
    @Namespace var animation
    
    var body: some View {
        VStack(spacing: 5) {
            MenuOfEventsView
            menuOfEventActive.getView(by: league, and: seasonListVM.seasonSelected ?? Season(season: ""))
                .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
        }
    }
    
    @ViewBuilder
    var MenuOfEventsView: some View {
        HStack(spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(SeasonOfLeagueMenu.allCases, id: \.self) { menu in
                        HStack {
                            menu.getIconView()
                                .fontWeight(menuOfEventActive == menu ? .bold : nil)
                            if menuOfEventActive == menu {
                                Text(menu.rawValue)
                                    .font(.callout.bold())
                            }
                            
                        }
                        .backgroundOfItemSelected(padding: 5, hasShimmer: false, isSelected: menuOfEventActive == menu, animation: animation)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                menuOfEventActive = menu
                            }
                        }
                        
                            
                        
                    }
                }
                
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .backgroundOfCardView()
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
            EventsForEachRoundInControlView(leagueID: league.idLeague ?? "")
            
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

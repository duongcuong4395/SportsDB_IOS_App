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
    
    @State var menuOfEventActive: SeasonOfLeagueMenu = .TableRanking
    
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

                    if seasonListVM.seasonSelected != nil {
                        MenuOfEventsView(menuOfEventActive: $menuOfEventActive)
                    }
                    
                    if seasonListVM.seasonSelected == nil  {
                        Text("Select season to see more about table rank and round events.")
                            .font(.caption2)
                    } else {
                        menuOfEventActive.getView(by: league, and: seasonListVM.seasonSelected ?? Season(season: ""))
                            .frame(maxHeight: DeviceSize.current.isPad ? UIScreen.main.bounds.height / 1.5 : UIScreen.main.bounds.height / 2.5)
                    }
                    
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 5)
        }
    }

}

struct MenuOfEventsView: View {
    
    //@State var menuOfEventActive: SeasonOfLeagueMenu = .TableRanking
    @Binding var menuOfEventActive: SeasonOfLeagueMenu
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Namespace var animation
    
    var body: some View {
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
                        .font(.callout.bold())
                        .padding(5)
                        .foregroundColor(menuOfEventActive == menu ? .black : (colorScheme == .light ? .gray : .white))
                        .themedBackground(.itemSelected(tintColor: .blue
                            , isSelected: menuOfEventActive == menu
                            , animationID: animation, animationName: "SeasonOfLeagueMenu"))
                        .onTapGesture {
                            withAnimation(.spring()) {
                                menuOfEventActive = menu
                            }
                        }
                    }
                }
                
            }
        }
        .padding(5)
        .themedBackground(.card(material: .none))
    }
}



//
//  LeagueDetailView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

struct LeagueDetailRouteView<
    viewForEventsPastLeague: View,
    viewForTeam: View,
        viewForSeason: View,
        viewForLeagueTable: View,
        viewForEventsPerRound: View,
        viewEventsSpecificView: View,
        viewForPreviousAndNextRounrEvent: View
    >: View {
    
    @EnvironmentObject var leagueDetailVM: LeagueDetailViewModel
    
    var listTeamByLeagueView: viewForTeam
    
    
    var seasonForLeagueView: viewForSeason
    var leagueTable: (withConditions: Bool, withView: viewForLeagueTable)
    //var eventsEachRoundOfLeagueAndSeason: (viewControl: (conditionToShow: Bool, view: viewForPreviousAndNextRounrEvent),
                                           //viewListEvents: (conditionToShow: Bool, view: viewForEventsPerRound))
    var events: (
        forPastLeague: (withTheRightConditions: Bool, withView: viewForEventsPastLeague),
        forEachRound: (inControl: (withTheRightConditions: Bool, withView: viewForPreviousAndNextRounrEvent),
                       inList: (withTheRightConditions: Bool, withView: viewForEventsPerRound)),
        forSpecific: (withTheRightConditions: Bool, withView: viewEventsSpecificView)
    )
    
    @State var isVisibleViews: (
        events: (
            forEachRound: Bool,
            inControl: Bool
        ),
        leagueTable: Bool
    ) = (events: (
        forEachRound: false,
        inControl: false
    ),
    leagueTable: false)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if let league = leagueDetailVM.league {
                TitleComponentView(title: "Trophy")
                TrophyView(league: league)
                SocialView(
                    facebook: league.facebook,
                    twitter: league.twitter,
                    instagram: league.instagram,
                    youtube: league.youtube,
                    website: league.website)
                
                TitleComponentView(title: "Teams")
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: AppUtility.columns) {
                        listTeamByLeagueView
                    }
                }
                .frame(height: UIScreen.main.bounds.height / 2)
                
                TitleComponentView(title: "Recent Events")
                events.forPastLeague.withView
                    .frame(height: UIScreen.main.bounds.height / 2)
                
                TitleComponentView(title: "Seasons")
                seasonForLeagueView
                
                if leagueTable.withConditions {
                    TitleComponentView(title: "Ranks")
                    leagueTable.withView
                        .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                }
                
                if events.forEachRound.inControl.withTheRightConditions {
                    TitleComponentView(title: "Events")
                    events.forEachRound.inControl.withView
                }
                
                if events.forEachRound.inList.withTheRightConditions {
                    events.forEachRound.inList.withView
                        .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                        
                }
                
                if events.forSpecific.withTheRightConditions {
                    TitleComponentView(title: "Events Specific")
                    events.forSpecific.withView
                        .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                }
                
                TitleComponentView(title: "Description")
                Text(league.descriptionEN ?? "")
                    .font(.caption)
                    .lineLimit(nil)
                    .frame(alignment: .leading)
                
                LeaguesAdsView(league: league)
            }
        }
        
        EmptyView()
    }
}








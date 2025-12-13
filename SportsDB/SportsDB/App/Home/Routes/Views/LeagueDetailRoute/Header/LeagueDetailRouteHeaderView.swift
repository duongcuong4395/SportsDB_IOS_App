//
//  LeagueDetailRouteHeaderView.swift
//  SportsDB
//
//  Created by Macbook on 6/8/25.
//

import SwiftUI
import Kingfisher

struct LeagueDetailRouteHeaderView: View {
    var league: League
    let tabs = LeagueDetailRouteMenu.allCases
    
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var leagueDetailVM: LeagueDetailViewModel
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var eventListVM: EventListViewModel
    @EnvironmentObject var countryListVM: CountryListViewModel
    @EnvironmentObject var sportVM: SportViewModel
    
    @EnvironmentObject var eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel
    @EnvironmentObject var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    @EnvironmentObject var eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                backRoute()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
            })
            if let league = leagueDetailVM.league {
                HStack(spacing: 5) {
                    KFImage(URL(string: league.badge ?? ""))
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                }
            }
            
            //Spacer()
            VStack {
                Text(league.leagueName ?? "")
                    .font(.caption.bold())
                Text(league.currentSeason ?? "")
                    .font(.caption)
                
                HStack {
                    SocialItemView(socialLink: league.youtube, iconName: "youtube", size: 15)
                    Spacer()
                    SocialItemView(socialLink: league.twitter, iconName: "twitter", size: 15)
                    Spacer()
                    SocialItemView(socialLink: league.instagram, iconName: "instagram", size: 15)
                    Spacer()
                    SocialItemView(socialLink: league.facebook, iconName: "facebook", size: 15)
                    //Spacer()
                    //SocialItemView(socialLink: website, iconName: "Sports")
                }
                .padding(.horizontal, 5)
            }
            
            //Spacer()
            if let league = leagueDetailVM.league {
                TrophyView(league: league, size: 60)
            }
            
        }
        //.backgroundOfRouteHeaderView(with: 70)
        .backgroundByTheme(for: .Header(height: 70))
    }
    
    func backRoute() {
        sportRouter.pop()
        eventListVM.resetAll()
        teamListVM.resetAll()
        leagueDetailVM.resetAll()
        seasonListVM.resetAll()
        leagueListVM.resetLeaguesTable()
        eventsRecentOfLeagueVM.resetAll()
        eventsPerRoundInSeasonVM.resetAll()
        eventsInSpecificInSeasonVM.resetAll()
    }
}

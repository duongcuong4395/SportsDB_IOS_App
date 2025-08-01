//
//  ListLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

struct ListLeagueRouteView: View {
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    @EnvironmentObject var leagueDetailVM: LeagueDetailViewModel
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    @EnvironmentObject var eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var countryListVM: CountryListViewModel
    @EnvironmentObject var sportVM: SportViewModel
    
    let country: String
    let sport: String
    
    private let badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (60, 60)
    var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    @State var reloadNumb: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    leagueListVM.resetAll()
                    sportRouter.pop()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                })
                .padding(5)
                Spacer()
            }
            switch leagueListVM.leaguesStatus {
            case .loading:
                Spacer()
                ProgressView()
                Spacer()
            case .success(data: _):
                VStack {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns) {
                            LeaguesView(leagues: leagueListVM.leagues, badgeImageSizePerLeague: badgeImageSizePerLeague, tappedLeague: tappedLeague)
                        }
                    }
                }
            case .idle:
                Spacer()
            case .failure(error: _):
                Spacer()
                Circle()
                    .onAppear{
                        Task {
                            reloadNumb += 1
                            guard reloadNumb <= 3 else { return }
                            await leagueListVM.fetchLeagues(country: country, sport: sportVM.sportSelected.rawValue)
                        }
                        
                    }
            }
        }
        .navigationBarHidden(true)
    }
    
    func tappedLeague(by league: League) {
        sportRouter.navigateToLeagueDetail(by: league.idLeague ?? "")
        leagueDetailVM.setLeague(by: league)
        
        Task {
            // Get list teams
            await teamListVM.getListTeams(leagueName: league.leagueName ?? "", sportName: sport, countryName: country)
            //await eventListVM.lookupEventsPastLeague(leagueID: league.idLeague ?? "")
            // Get list Season
            await seasonListVM.getListSeasons(leagueID: league.idLeague ?? "")
        }
        
        eventsRecentOfLeagueVM.getEvents(by: league.idLeague ?? "")
    }
}

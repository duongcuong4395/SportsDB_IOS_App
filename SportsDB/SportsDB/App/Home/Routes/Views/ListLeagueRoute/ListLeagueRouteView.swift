//
//  ListLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

struct ListLeagueRouteView: View {
    var body: some View {
        RouteGenericView(
            headerView: ListLeagueRouteHeaderView()
            , contentView: ListLeagueRouteContentView())
    }
}

struct ListLeagueRouteContentView: View {
    @EnvironmentObject var countryListVM: CountryListViewModel
    @EnvironmentObject var sportVM: SportViewModel
    
    var body: some View {
        if let countrySelected = countryListVM.countrySelected {
            
            ScrollView(showsIndicators: false) {
                ListLeaguesView(country: countrySelected.name, sport: sportVM.sportSelected.rawValue, onRetry: {
                    print("=== onRetry ListLeaguesView", countrySelected)
                })
            }
        }
        
    }
}

struct ListLeagueRouteHeaderView: View {
    @EnvironmentObject var countryListVM: CountryListViewModel
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                leagueListVM.resetAll()
                sportRouter.pop()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
            })
            if let country = countryListVM.countrySelected {
                HStack(spacing: 5) {
                    KFImage(URL(string: country.getFlag(by: .Medium)))
                        .placeholder {
                            ProgressView()
                        }
                        .font(.caption)
                        .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                    Text(country.name)
                        .font(.body.bold())
                }
            }
            Spacer()
        }
        .backgroundOfRouteHeaderView(with: 70)
    }
}

struct ListLeaguesView: View {
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var leagueDetailVM: LeagueDetailViewModel
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    @EnvironmentObject var eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel
    
    let country: String
    let sport: String
    
    var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    private let badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (60, 60)
    
    @State var numbRetry: Int = 0
    @State var onRetry: () -> Void
    
    var body: some View {
        switch leagueListVM.leaguesStatus {
        case .loading:
            Spacer()
            ProgressView()
            Spacer()
        case .success(data: _):
            LazyVGrid(columns: columns) {
                LeaguesView(leagues: leagueListVM.leagues, badgeImageSizePerLeague: badgeImageSizePerLeague, tappedLeague: tappedLeague)
            }
        case .idle:
            Spacer()
        case .failure(error: _):
            Text("Please return in a few minutes.")
                .font(.caption2.italic())
                .onAppear {
                    numbRetry += 1
                    guard numbRetry <= 3 else { numbRetry = 0 ; return }
                    onRetry()
                }
        }
        
    }
    
    func tappedLeague(by league: League) {
        
        Task {
            await seasonListVM.getListSeasons(leagueID: league.idLeague ?? "")
            leagueDetailVM.setLeague(by: league)
            sportRouter.navigateToLeagueDetail(by: league.idLeague ?? "")
            // Get list teams
            await teamListVM.getListTeams(leagueName: league.leagueName ?? "", sportName: sport, countryName: country)
        }
        
        eventsRecentOfLeagueVM.getEvents(by: league.idLeague ?? "")
    }
    
}

struct LeaguesSuccessView: View {
    let leagues: [League] // Adjust type
    let columns: [GridItem]
    private let badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (60, 60)
    let tappedLeague: (League) -> Void
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            LeaguesView(
                leagues: leagues,
                badgeImageSizePerLeague: badgeImageSizePerLeague,
                tappedLeague: tappedLeague
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
}

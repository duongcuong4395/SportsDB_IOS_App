//
//  ListLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

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
    
    @State var isSticky: Bool = false
    var animation: Namespace.ID
    
    var body: some View {
        VStack {
            // MARK: Header
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
                            .font(.caption)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .frame(height: 60)
            .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    //.opacity(progress)
                    .ignoresSafeArea(.all)
            }
            
            // MARK: Content
            ScrollView(showsIndicators: false) {
                ListLeaguesView(country: country, sport: sport)
                    //.padding(.horizontal, 16)
            }
            
        }
    }
}

struct ListLeaguesView: View {
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var countryListVM: CountryListViewModel
    @EnvironmentObject var sportVM: SportViewModel
    @EnvironmentObject var leagueDetailVM: LeagueDetailViewModel
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    @EnvironmentObject var eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel
    
    
    let country: String
    let sport: String
    
    var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    private let badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (60, 60)
    @State var reloadNumb: Int = 0
    @State var isSticky: Bool = false
    
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
    
    func tappedLeague(by league: League) {
        
        Task {
            await seasonListVM.getListSeasons(leagueID: league.idLeague ?? "")
            leagueDetailVM.setLeague(by: league)
            sportRouter.navigateToLeagueDetail(by: league.idLeague ?? "")
            // Get list teams
            await teamListVM.getListTeams(leagueName: league.leagueName ?? "", sportName: sport, countryName: country)
            //await eventListVM.lookupEventsPastLeague(leagueID: league.idLeague ?? "")
            // Get list Season
            
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

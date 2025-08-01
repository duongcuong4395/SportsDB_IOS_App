//
//  LeagueDetailView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

struct LeagueDetailRouteView: View {
    
    var leagueID: String
    
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var leagueDetailVM: LeagueDetailViewModel
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var eventListVM: EventListViewModel
    @EnvironmentObject var countryListVM: CountryListViewModel
    @EnvironmentObject var sportVM: SportViewModel
    
    @EnvironmentObject var eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel
    
    //var eventsEachRoundOfLeagueAndSeason: (viewControl: (conditionToShow: Bool, view: viewForPreviousAndNextRounrEvent),
                                           //viewListEvents: (conditionToShow: Bool, view: viewForEventsPerRound))
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    sportRouter.pop()
                    eventListVM.resetAll()
                    teamListVM.resetAll()
                    leagueDetailVM.resetAll()
                    seasonListVM.resetAll()
                    leagueListVM.resetLeaguesTable()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                })
                .padding(5)
                Spacer()
            }
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
                    buildTeamListView(onRetry: {
                        Task {
                            await teamListVM.getListTeams(
                                leagueName: league.leagueName ?? ""
                                , sportName: sportVM.sportSelected.rawValue
                                , countryName: countryListVM.countrySelected?.name ?? "")
                        }
                    })
                    
                    .frame(height: UIScreen.main.bounds.height / 2)
                    
                    TitleComponentView(title: "Recent Events")
                    BuildEventsForPastLeagueView(onRetry: {
                        eventsRecentOfLeagueVM.getEvents(by: leagueDetailVM.league?.idLeague ?? "")
                    })
                    
                    TitleComponentView(title: "Seasons")
                    BuildSeasonForLeagueView(leagueID: leagueID)
                    
                    if seasonListVM.seasonSelected != nil && leagueListVM.leaguesTable.count > 0 {
                        TitleComponentView(title: "Ranks")
                        BuildLeagueTableView(onRetry: {
                            
                        })
                        .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                    }
                    
                    if seasonListVM.seasonSelected != nil {
                        TitleComponentView(title: "Events")
                        BuildEventsForEachRoundInControl(leagueID: leagueID)
                    }
                    
                    if seasonListVM.seasonSelected != nil {
                        BuildEventsForEachRoundView()
                            .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                    }
                    
                    if seasonListVM.seasonSelected != nil {
                        TitleComponentView(title: "Events Specific")
                        BuildEventsForSpecific()
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
        }
        
        
    }
}

struct BuildLeagueTableView: View, SelectTeamDelegate {
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventListVM: EventListViewModel
    
    @EnvironmentObject var leagueListVM: LeagueListViewModel
    
    var onRetry: () -> Void
    
    var body: some View {
        switch leagueListVM.leaguesTableStatus {
        case .idle:
            EmptyView()
        case .loading:
            EmptyView()
        case .success(_):
            LeagueTableView(
                leaguesTable: leagueListVM.leaguesTable
                , showRanks: $leagueListVM.showRanks
                , tappedTeam: { leagueTable in
                    withAnimation {
                        teamDetailVM.teamSelected = nil
                        trophyListVM.resetTrophies()
                        playerListVM.resetPlayersByLookUpAllForaTeam()
                    }
                    selectTeam(by: leagueTable.teamName ?? "")
                    sportRouter.navigateToTeamDetail(by: leagueTable.idTeam ?? "")
                })
        case .failure(_):
            ErrorStateView(error: "", onRetry: {})
                .onAppear{
                    onRetry()
                }
        }
    }
}


struct buildTeamListView: View, SelectTeamDelegate {
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventListVM: EventListViewModel
    
    private let badgeImageSizePerLeague: (width: CGFloat, height: CGFloat) = (60, 60)
    
    let onRetry: () -> Void
    
    var body: some View {
        switch teamListVM.teamsStatus {
        case .idle:
            IdleStateView(kindName: "teams", onLoadTapped: {})
        case .loading:
            LoadingStateView(kindName: "teams")
        case .success(_):
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: AppUtility.columns) {
                    TeamListView(
                        teams: teamListVM.teams,
                        badgeImageSizePerTeam: badgeImageSizePerLeague,
                        teamTapped: { team in
                            
                            withAnimation {
                                teamDetailVM.teamSelected = nil
                                trophyListVM.resetTrophies()
                                playerListVM.resetPlayersByLookUpAllForaTeam()
                            }
                            
                            teamDetailVM.setTeam(by: team)
                            selectTeam(by: team.teamName)
                            
                            guard let team = teamDetailVM.teamSelected else { return }
                            
                            sportRouter.navigateToTeamDetail(by: team.idTeam ?? "")
                        }
                    )
                }
            }
            
            
        case .failure(let error):
            ErrorStateView(error: error, onRetry: {})
                .onAppear{
                    onRetry()
                }
        }
    }
}

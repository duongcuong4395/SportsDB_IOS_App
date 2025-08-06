//
//  LeagueDetailRouteContentView.swift
//  SportsDB
//
//  Created by Macbook on 6/8/25.
//

import SwiftUI

struct LeagueDetailRouteContentView: View {
    var league: League
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
    @EnvironmentObject var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    @EnvironmentObject var eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    
    @Binding var selectedTab: Int
    let tabs = LeagueDetailRouteMenu.allCases
    @State private var timer: Timer?
    @State private var dragOffset: CGFloat = 0
    
    @Namespace var animation
    
    @State private var contentKey = UUID() // Key to force content refresh
    
    // Tắt auto scroll - đặt thành false để tắt
    let autoScrollEnabled: Bool = false
    let autoScrollInterval: TimeInterval = 3.0
    
    
    
    @State private var tabHeights: [CGFloat] = []
    
    var body: some View {
        VStack(spacing: 5) {
            tabBarView
            
            TabView(selection: $selectedTab) {
                generalTabContent
                    //.frostedGlass()
                    .liquidGlass(intensity: 0.8)
                /*
                    .liquidGlass(
                        intensity: 0.3,
                        tintColor: .white,
                        isInteractive: true,
                        hasShimmer: false,  // Mới: kiểm soát shimmer
                        hasGlow: true      // Mới: kiểm soát glow
                    )
                */
                    .padding(.horizontal, 5)
                    .tag(0)
                teamsTabContent
                    .liquidGlass(intensity: 0.8)
                    .padding(.horizontal, 5)
                    .tag(1)
                eventsTabContent
                    .liquidGlass(intensity: 0.8)
                    .padding(.horizontal, 5)
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
        }
        .padding(.bottom, 5)
    }
    
    private var tabBarView: some View {
        HStack(spacing: 20) {
            ForEach(0..<tabs.count, id: \.self) { index in
                MenuTabIndicatorView(
                    menu: tabs[index],
                    isSelected: selectedTab == index
                )
                
                .background {
                    if selectedTab == index {
                        ZStack {
                            LiquidGlassLibrary.GlassBackground(intensity: 0.9)
                            LiquidGlassLibrary.ShimmeringGlass()
                        }
                        .animation(.easeInOut(duration: 0.3), value: selectedTab == index)
                        .matchedGeometryEffect(id: "LeagueDetailRouteMenu", in: animation)
                        /*
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedTab == index ? tabs[index].color.opacity(0.1) : Color.clear)
                            .animation(.easeInOut(duration: 0.3), value: selectedTab == index)
                            .matchedGeometryEffect(id: "LeagueDetailRouteMenu", in: animation)
                        */
                    }
                }
                .onTapGesture {
                    withAnimation {
                        selectedTab = index
                    }
                }
                .id(index)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background{
            Color.clear
                .liquidGlass(intensity: 0.8, cornerRadius: 20)
        }
    }
    
    private var generalTabContent: some View {
        VStack(spacing: 5) {
            ScrollView(showsIndicators: false) {
                VStack {
                    TitleComponentView(title: "Description")
                        //.padding(5)
                    Text(league.descriptionEN ?? "")
                        .font(.caption)
                        .lineLimit(nil)
                        .frame(alignment: .leading)
                        //.padding(5)
                    
                    LeaguesAdsView(league: league)
                }
                
            }
            .padding()
        }
        
        
    }
    
    private var teamsTabContent: some View {
        VStack {
            buildTeamListView(onRetry: {
                Task {
                    await teamListVM.getListTeams(
                        leagueName: league.leagueName ?? ""
                        , sportName: sportVM.sportSelected.rawValue
                        , countryName: countryListVM.countrySelected?.name ?? "")
                }
            })
            Spacer()
        }
    }
    
    private var eventsTabContent: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack{
                    TitleComponentView(title: "Recent Events")
                    BuildEventsForPastLeagueView(onRetry: {
                        eventsRecentOfLeagueVM.getEvents(by: leagueDetailVM.league?.idLeague ?? "")
                    })
                    
                    TitleComponentView(title: "Seasons")
                    BuildSeasonForLeagueView(leagueID: leagueID)
                    
                    /*
                        .onAppear{
                            guard let season = seasonListVM.seasonSelected else { return }
                             
                            eventListVM.setCurrentRound(by: 1) { round in
                                eventsPerRoundInSeasonVM.getEvents(of: leagueID, per: "\(round)", in: season.season)
                            }
                            
                            leagueListVM.resetLeaguesTable()
                            
                            Task {
                                await leagueListVM.lookupLeagueTable(
                                    leagueID: leagueID,
                                    season: season.season)
                                
                                
                                await eventsInSpecificInSeasonVM.getEvents(
                                    leagueID: leagueID,
                                    season: season.season)
                            }
                            
                        }
                    */
                    
                    if seasonListVM.seasonSelected == nil {
                        Text("Select season to see more about table rank and round events.")
                            .font(.caption2)
                    }
                    
                    if seasonListVM.seasonSelected != nil {
                        TitleComponentView(title: "Ranks")
                        BuildLeagueTableView(onRetry: {
                            Task {
                                guard let season = seasonListVM.seasonSelected else { return }
                                await leagueListVM.lookupLeagueTable(
                                    leagueID: leagueID,
                                    season: season.season)
                            }
                        })
                        .frame(maxHeight: UIScreen.main.bounds.height / 2.5)

                        TitleComponentView(title: "Events")
                        BuildEventsForEachRoundInControl(leagueID: leagueID)
                        
                        BuildEventsForEachRoundView(onRetry: {  })
                            .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                        
                        TitleComponentView(title: "Events Specific")
                        BuildEventsForSpecific(onRetry: {  })
                            .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                    }
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
    
    @State var numbRetry: Int = 0
    
    var body: some View {
        switch leagueListVM.leaguesTableStatus {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
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
            Text("Please return in a few minutes")
                .font(.caption2)
                .onAppear{
                    numbRetry += 1
                    guard numbRetry <= 3 else { numbRetry = 0 ; return }
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

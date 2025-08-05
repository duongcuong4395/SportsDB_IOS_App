//
//  LeagueDetailView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

enum LeagueDetailRouteMenu: String, CaseIterable {
    case General
    case Teams
    case Events
    
    var title: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .General:
            return "info.circle.fill"
        case .Teams:
            return "person.3.fill"
        case .Events:
            return "calendar"
        }
    }
    
    var color: Color {
        switch self {
        case .General:
            return .blue
        case .Teams:
            return .green
        case .Events:
            return .orange
        }
    }
}

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
    @EnvironmentObject var eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    @EnvironmentObject var eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    
    let tabs = LeagueDetailRouteMenu.allCases
    @State private var selectedTab = 0
    
    @State var isSticky: Bool = false
    var body: some View {
        
        if let league = leagueDetailVM.league {
            VStack {
                // MARK: Header
                HStack(spacing: 10) {
                    Button(action: {
                        sportRouter.pop()
                        eventListVM.resetAll()
                        teamListVM.resetAll()
                        leagueDetailVM.resetAll()
                        seasonListVM.resetAll()
                        leagueListVM.resetLeaguesTable()
                        eventsRecentOfLeagueVM.resetAll()
                        eventsPerRoundInSeasonVM.resetAll()
                        eventsInSpecificInSeasonVM.resetAll()
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
                            VStack {
                                Text(league.leagueName ?? "")
                                    .font(.caption.bold())
                                Text(league.currentSeason ?? "")
                                    .font(.caption)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: 60)
                .background {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea(.all)
                }
                
                // MARK: Content
                LeagueDetailRouteContentView(league: league, leagueID: leagueID, selectedTab: $selectedTab)
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
            IdleStateView(kindName: "League table", onLoadTapped: {})
        case .loading:
            LoadingStateView(kindName: "League table")
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
    @State private var timer: Timer?
    @State private var dragOffset: CGFloat = 0
    
    @Namespace var animation
    
    @State private var contentKey = UUID() // Key to force content refresh
    
    // Tắt auto scroll - đặt thành false để tắt
    let autoScrollEnabled: Bool = false
    let autoScrollInterval: TimeInterval = 3.0
    
    let tabs = LeagueDetailRouteMenu.allCases
    
    @State private var tabHeights: [CGFloat] = []
    
    var body: some View {
        VStack(spacing: 0) {
            tabBarView
            
            TabView(selection: $selectedTab) {
                generalTabContent
                    .tag(0)
                teamsTabContent
                    .tag(1)
                eventsTabContent
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
        }
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
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedTab == index ? tabs[index].color.opacity(0.1) : Color.clear)
                            .animation(.easeInOut(duration: 0.3), value: selectedTab == index)
                            .matchedGeometryEffect(id: "LeagueDetailRouteMenu", in: animation)
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
    }
    
    private var generalTabContent: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                TitleComponentView(title: "Trophy")
                TrophyView(league: league)
                
                TitleComponentView(title: "Description")
                Text(league.descriptionEN ?? "")
                    .font(.caption)
                    .lineLimit(nil)
                    .frame(alignment: .leading)
                
                LeaguesAdsView(league: league)
            }
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
                    
                        .onAppear{
                            print("=== Season onApear", seasonListVM.seasons.count)
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
                    
                    
                    TitleComponentView(title: "Ranks")
                    BuildLeagueTableView(onRetry: {})
                    .frame(maxHeight: UIScreen.main.bounds.height / 2.5)

                    TitleComponentView(title: "Events")
                    BuildEventsForEachRoundInControl(leagueID: leagueID)
                    
                    BuildEventsForEachRoundView()
                        .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                    
                    TitleComponentView(title: "Events Specific")
                    BuildEventsForSpecific()
                        .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                }
            }
            
        }
    }
    
}


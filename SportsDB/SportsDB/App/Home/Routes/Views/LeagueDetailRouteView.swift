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
    
    //var eventsEachRoundOfLeagueAndSeason: (viewControl: (conditionToShow: Bool, view: viewForPreviousAndNextRounrEvent),
                                           //viewListEvents: (conditionToShow: Bool, view: viewForEventsPerRound))
    @State var isSticky: Bool = false
    var body: some View {
        /*
        if let league = leagueDetailVM.league {
            LeagueDetailRouteContentView(
                league: league, leagueID: leagueID)
        }
        */
        
        ResizableHeaderScrollView(
            minimumHeight: 50,
            maximumHeight: 70,
            ignoresSafeAreaTop: true,
            isSticky: isSticky
        ) { progress, safeArea in
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
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                            .scaleEffect(1 - ( 0.2 * progress), anchor: .leading)
                        
                        //.matchedGeometryEffect(id: "country_\(country.name)", in: animation)
                        
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
            .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(progress)
                    .ignoresSafeArea(.all)
            }
        } content: {
            Group {
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
                        .onAppear{
                            print("=== Season onApear", seasonListVM.seasons.count)
                            guard let season = seasonListVM.seasonSelected else { return }
                             
                            eventListVM.setCurrentRound(by: 1) { round in
                                eventsPerRoundInSeasonVM.getEvents(of: leagueID, per: "\(round)", in: season.season)
                            }
                            
                            withAnimation(.spring()) {
                                
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
                    
                    TitleComponentView(title: "Description")
                    Text(league.descriptionEN ?? "")
                        .font(.caption)
                        .lineLimit(nil)
                        .frame(alignment: .leading)
                    
                    LeaguesAdsView(league: league)
                }
            }
        }
        
        
        /*
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
        */
        
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
    
    @State private var selectedTab = 0
    @State private var timer: Timer?
    @State private var dragOffset: CGFloat = 0
    
    // Tắt auto scroll - đặt thành false để tắt
    let autoScrollEnabled: Bool = false
    let autoScrollInterval: TimeInterval = 3.0
    
    let tabs = LeagueDetailRouteMenu.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab Bar với Scrolling Indicators
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(0..<tabs.count, id: \.self) { index in
                            MenuTabIndicatorView(
                                menu: tabs[index],
                                isSelected: selectedTab == index
                            )
                            .onTapGesture {
                                /*
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = index
                                    if autoScrollEnabled {
                                        stopAutoScroll()
                                        startAutoScroll()
                                    }
                                }
                                */
                                // Không đặt animation ở đây để TabView tự xử lý
                                selectedTab = index
                                if autoScrollEnabled {
                                    stopAutoScroll()
                                    startAutoScroll()
                                }
                            }
                            .id(index)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .onChange(of: selectedTab) { newValue in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [Color.black.opacity(0.1), Color.clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Content Area
            TabView(selection: $selectedTab) {
                View1(league: league)
                .tag(0)
                
                // MARK: Teams
                VStack {
                    //TitleComponentView(title: "Teams")
                    buildTeamListView(onRetry: {
                        Task {
                            await teamListVM.getListTeams(
                                leagueName: league.leagueName ?? ""
                                , sportName: sportVM.sportSelected.rawValue
                                , countryName: countryListVM.countrySelected?.name ?? "")
                        }
                    })
                    //.frame(height: UIScreen.main.bounds.height / 2)
                }
                .tag(1)
                
                // MARK: Events
                VStack {
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
                            
                            withAnimation(.spring()) {
                                
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
                .tag(2)
                /*
                ForEach(0..<tabs.count, id: \.self) { index in
                    MenuTabContentView(menu: tabs[index])
                        .tag(index)
                }
                 */
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            //.animation(.easeInOut(duration: 0.4), value: selectedTab)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                        if autoScrollEnabled {
                            stopAutoScroll()
                        }
                    }
                    .onEnded { value in
                        dragOffset = 0
                        if autoScrollEnabled {
                            startAutoScroll()
                        }
                    }
            )
        }
        .onAppear {
            if autoScrollEnabled {
                startAutoScroll()
            }
        }
        .onDisappear {
            if autoScrollEnabled {
                stopAutoScroll()
            }
        }
    }
    
    private func startAutoScroll() {
       guard autoScrollEnabled else { return }
       timer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { _ in
           // Không đặt animation ở đây, để TabView tự xử lý
           selectedTab = (selectedTab + 1) % tabs.count
       }
   }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
}


struct View1: View {
    var league: League
    var body: some View {
        ScrollView{
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
}

//
//  TeamDetailRouteContentView.swift
//  SportsDB
//
//  Created by Macbook on 5/8/25.
//

import SwiftUI

struct TeamDetailRouteContentView: View {
    var team: Team
    @State var selectedTab: Int = 0
    let tabs = TeamDetailRouteMenu.allCases
    
    
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    @State var trophyGroup: [TrophyGroup] = []
    @State var isVisible: Bool = false
    
    @Namespace var animation
    
    @State var isVisibleViews: (
        forEvents: Bool,
        forEquipment: Bool
    ) = (forEvents: false,
         forEquipment: false)
    
    var body: some View {
        VStack {
            tabBarView
            
            TabView(selection: $selectedTab) {
                GeneralView
                    .tag(0)
                if playerListVM.playersByLookUpAllForaTeam.count > 0 {
                    PlayersView
                        .tag(1)
                }
                
                EventsView
                    .tag(2)
                TrophiesView
                    .tag(3)
                EquipmentsView
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
        }
    }
    
    var tabBarView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
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
                                .matchedGeometryEffect(id: "TeamDetailRouteMenu", in: animation)
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
        
    }
    
    func groupTrophies(_ trophies: [Trophy]) -> [TrophyGroup] {
        let grouped = Dictionary(grouping: trophies) { trophy in
            TrophyGroupKey(title: trophy.title, honourArtworkLink: trophy.honourArtworkLink)
        }

        return grouped.map { key, values in
            TrophyGroup(
                title: key.title,
                honourArtworkLink: key.honourArtworkLink,
                listSeason: values.map { $0.season }.sorted()
            )
        }
    }
    
    var GeneralView: some View {
        ScrollView(showsIndicators: false) {
            TeamAdsView(team: team)
        }
    }
    
    var EquipmentsView: some View {
        EquipmentsListView(equipments: teamDetailVM.equipments)
            .onAppear{
                isVisibleViews.forEquipment = true
            }
            //.slideInEffect(isVisible: $isVisibleViews.forEquipment, delay: 0.5, direction: .leftToRight)
    }
    
    var TrophiesView: some View {
        VStack {
            if trophyListVM.trophyGroups.count > 0 {
                TrophyListView(trophyGroup: trophyListVM.trophyGroups)
            }
        }
    }
    
    var PlayersView: some View {
        BuildPlayersForTeamDetailView(team: team, progressing: false)
    }

    var EventsView: some View {
        BuildEventsOfTeamByScheduleView(team: team)
            .onAppear{
                isVisibleViews.forEvents = true
            }
            .slideInEffect(isVisible: $isVisibleViews.forEvents, delay: 0.5, direction: .leftToRight)
    }
}

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
                    .liquidGlass(intensity: 0.8)
                    .padding(.horizontal, 5)
                    .tag(0)
                if playerListVM.playersByLookUpAllForaTeam.count > 0 {
                    PlayersView
                        .liquidGlass(intensity: 0.8)
                        .padding(.horizontal, 5)
                        .tag(1)
                }
                
                EventsView
                    .liquidGlass(intensity: 0.8)
                    .padding(.horizontal, 5)
                    .tag(2)
                TrophiesView
                    .liquidGlass(intensity: 0.8)
                    .padding(.horizontal, 5)
                    .tag(3)
                EquipmentsView
                    .liquidGlass(intensity: 0.8)
                    .padding(.horizontal, 5)
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
        }
    }
    
    var tabBarView: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
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
                                .matchedGeometryEffect(id: "TeamDetailRouteMenu", in: animation)
                                /*
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedTab == index ? tabs[index].color.opacity(0.1) : Color.clear)
                                    .animation(.easeInOut(duration: 0.3), value: selectedTab == index)
                                    .matchedGeometryEffect(id: "TeamDetailRouteMenu", in: animation)
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
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background{
            Color.clear
                .liquidGlass(intensity: 0.8, cornerRadius: 20)
        }
        .padding(.horizontal, 5)
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
        VStack {
            ScrollView(showsIndicators: false) {
                TeamAdsView(team: team)
            }
        }
        .padding()
    }
    
    var EquipmentsView: some View {
        EquipmentsListView(equipments: teamDetailVM.equipments)
            .onAppear{
                isVisibleViews.forEquipment = true
            }
            //.slideInEffect(isVisible: $isVisibleViews.forEquipment, delay: 0.5, direction: .leftToRight)
            .padding(.vertical)
    }
    
    var TrophiesView: some View {
        VStack {
            if trophyListVM.trophyGroups.count > 0 {
                TrophyListView(trophyGroup: trophyListVM.trophyGroups)
            }
        }
        .padding(.vertical)
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
            .padding(.vertical)
    }
}

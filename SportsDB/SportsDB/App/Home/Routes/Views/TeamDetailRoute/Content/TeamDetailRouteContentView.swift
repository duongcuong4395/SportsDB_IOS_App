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
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @State var isVisibleViews: (
        forEvents: Bool,
        forEquipment: Bool
    ) = (forEvents: false,
         forEquipment: false)
    
    var body: some View {
        VStack {
            MenuOfTeamDetailRouteView(selectedTab: $selectedTab)
            
            TabView(selection: $selectedTab) {
                GeneralTabOfTeamDetailRouteView(team: team)
                    .liquidGlass(intensity: 0.8)
                    .padding(.horizontal, 5)
                    .tag(0)
                if playerListVM.playersByLookUpAllForaTeam.count > 0 {
                    ListPlayerTabOfTeamDetailRouteView(team: team)
                        .liquidGlass(intensity: 0.8)
                        .padding(.horizontal, 5)
                        .tag(1)
                }
                
                ListEventOfTeamDetailRouteView(team: team, isVisibleViews: $isVisibleViews)
                    .liquidGlass(intensity: 0.8)
                    .padding(.horizontal, 5)
                    .tag(2)
                
                TrophiesTabOfTeamDetailRouteView()
                    .liquidGlass(intensity: 0.8)
                    .padding(.horizontal, 5)
                    .tag(3)
                
                EquipmentsTabOfTeamDetailRouteView(isVisibleViews: $isVisibleViews)
                    .liquidGlass(intensity: 0.8)
                    .padding(.horizontal, 5)
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
        }
    }
}








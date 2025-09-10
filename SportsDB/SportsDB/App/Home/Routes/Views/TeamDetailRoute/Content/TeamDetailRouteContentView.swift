//
//  TeamDetailRouteContentView.swift
//  SportsDB
//
//  Created by Macbook on 5/8/25.
//

import SwiftUI

struct TeamDetailRouteContentView: View {
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    //@Binding var team: Team
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
                GeneralTabOfTeamDetailRouteView()
                    .backgroundOfCardView()
                    .tag(0)
                    
                if playerListVM.playersByLookUpAllForaTeam.count > 0 {
                    ListPlayerTabOfTeamDetailRouteView()
                        .backgroundOfCardView()
                        .tag(1)
                }
                
                ListEventOfTeamDetailRouteView(isVisibleViews: $isVisibleViews)
                    .backgroundOfCardView()
                    .tag(2)
                
                TrophiesTabOfTeamDetailRouteView()
                    .backgroundOfCardView()
                    .tag(3)
                
                EquipmentsTabOfTeamDetailRouteView(isVisibleViews: $isVisibleViews)
                    .backgroundOfCardView()
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
        }
    }
}








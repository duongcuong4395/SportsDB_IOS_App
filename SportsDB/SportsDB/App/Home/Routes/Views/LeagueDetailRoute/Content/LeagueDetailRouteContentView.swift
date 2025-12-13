//
//  LeagueDetailRouteContentView.swift
//  SportsDB
//
//  Created by Macbook on 6/8/25.
//

import SwiftUI

struct LeagueDetailRouteContentView: View {
    var league: League
    @State var selectedTab: Int = 0
    
    var body: some View {
        VStack(spacing: 5) {
            
            MenuOfLeagueDetailRouteView(selectedTab: $selectedTab)
            
            TabView(selection: $selectedTab) {
                GeneralTabOfLeagueDetailRouteView(league: league)
                    .backgroundByTheme(for: .Card(material: .none, cornerRadius: .moderateAngle))
                    .tag(0)
                    
                    
                TeamsTabOfLeagueDetailRouteView(league: league)
                    .backgroundByTheme(for: .Card(material: .none, cornerRadius: .moderateAngle))
                    .tag(1)
                    
                EventsTabOfLeagueDetailRouteView(league: league)
                    .backgroundByTheme(for: .Card(material: .none, cornerRadius: .moderateAngle))
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
        }
        .padding(.bottom, 5)
    }
}









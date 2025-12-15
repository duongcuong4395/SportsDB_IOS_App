//
//  MenuOfLeagueDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct MenuOfLeagueDetailRouteView: View {
    @Binding var selectedTab: Int
    @Namespace var animation
    var body: some View {
        HStack(spacing: 20) {
            ForEach(0..<LeagueDetailRouteMenu.allCases.count, id: \.self) { index in
                MenuTabIndicatorView(
                    menu: LeagueDetailRouteMenu.allCases[index],
                    isSelected: selectedTab == index
                )
                .themedBackground(.itemSelected(
                    tintColor: .white
                    , isSelected: selectedTab == index
                    , animationID: animation, animationName: "LeagueDetailRouteMenu"))
                .onTapGesture {
                    withAnimation {
                        selectedTab = index
                    }
                }
                .id(index)
            }
        }
        .padding(5)
        .padding(.horizontal, 5)
        .themedBackground(.card(material: .none))
        .padding(.horizontal, 5)
    }
}

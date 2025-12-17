//
//  MenuOfTeamDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct MenuOfTeamDetailRouteView: View {
    @Binding var selectedTab: Int
    @Namespace var animation
    
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<TeamDetailRouteMenu.allCases.count, id: \.self) { index in
                        MenuTabIndicatorView(
                            menu: TeamDetailRouteMenu.allCases[index],
                            isSelected: selectedTab == index
                        )
                        .themedBackground(.itemSelected(
                            tintColor: .blue
                            , isSelected: selectedTab == index
                            , animationID: animation, animationName: "TeamDetailRouteMenu"))
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
        .themedBackground(.card(tintColor: .white, cornerRadius: 20))
        .padding(.horizontal, 5)
    }
}

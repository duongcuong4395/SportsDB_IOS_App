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
                        .background {
                            if selectedTab == index {
                                ZStack {
                                    LiquidGlassLibrary.GlassBackground(intensity: 0.9)
                                    LiquidGlassLibrary.ShimmeringGlass()
                                }
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
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background{
            Color.clear
                .liquidGlass(intensity: 0.8, cornerRadius: 20)
        }
        .padding(.horizontal, 5)
    }
}

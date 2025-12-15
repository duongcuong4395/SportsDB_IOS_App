//
//  SeasonForLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

struct SeasonForLeagueView: View {
    @EnvironmentObject var seasonListVM: SeasonListViewModel
    
    var tappedSeason: (Season) -> Void
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Namespace var animation
    
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(seasonListVM.seasons, id: \.season) { season in
                        Text("\(season.season)")
                            .font(.callout.bold())
                            .padding(5)
                            .foregroundColor(season == seasonListVM.seasonSelected ? .black : (colorScheme == .light ? .gray : .white))
                            .themedBackground(.itemSelected(
                                tintColor: .blue
                                , isSelected: season == seasonListVM.seasonSelected
                                , animationID: animation, animationName: "season"))
                            .onTapGesture {
                                withAnimation {
                                    tappedSeason(season)
                                }
                            }
                    }
                }
            }
        }
        .padding(5)
        .themedBackground(.card(cornerRadius: 20, material: .none))
    }
}

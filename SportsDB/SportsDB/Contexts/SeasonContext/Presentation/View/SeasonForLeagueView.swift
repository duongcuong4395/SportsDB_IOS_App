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
    
    @Namespace var animation
    
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(seasonListVM.seasons, id: \.season) { season in
                        Text("\(season.season)")
                            .itemSelected(isSelected: season == seasonListVM.seasonSelected, animation: animation)
                            .onTapGesture {
                                withAnimation {
                                    tappedSeason(season)
                                }
                                
                            }
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
    }
}

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
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(seasonListVM.seasons, id: \.season) { season in
                        
                        let isSelected = season == seasonListVM.seasonSelected
                        
                        Text("\(season.season)")
                            .font(.callout.bold())
                            .padding(5)
                            .background{
                                if season == seasonListVM.seasonSelected {
                                    Color.clear
                                        .background(.thinMaterial.opacity(season == seasonListVM.seasonSelected  ? 1 : 0)
                                                , in: RoundedRectangle(cornerRadius: 25))
                                        .matchedGeometryEffect(id: "season", in: animation)
                                }
                                
                            }
                            .onTapGesture {
                                withAnimation {
                                    tappedSeason(season)
                                }
                                
                            }
                    }
                }
            }
        }
    }
}

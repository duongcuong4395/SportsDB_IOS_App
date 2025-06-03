//
//  SeasonForLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

struct SeasonForLeagueView: View {
    var seasons: [Season]
    var seasonSelected: Season?
    var tappedSeason: (Season) -> Void
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(seasons, id: \.season) { season in
                        
                        let isSelected = season == seasonSelected
                        
                        Text("\(season.season)")
                            .font(.callout.bold())
                            .padding(5)
                            .background(.thinMaterial.opacity(isSelected  ? 1 : 0)
                                        , in: RoundedRectangle(cornerRadius: 25))
                            .onTapGesture {
                                tappedSeason(season)
                            }
                    }
                }
            }
        }
    }
}

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
                            .backgroundByTheme(for: .ItemSelected(isSelected: season == seasonListVM.seasonSelected, cornerRadius: .moderateAngle, animation: animation))
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
        //.padding(.vertical, 5)
        //.padding(.horizontal, 5)
        .backgroundByTheme(for: .Card(material: .none, cornerRadius: .moderateAngle))
    }
}

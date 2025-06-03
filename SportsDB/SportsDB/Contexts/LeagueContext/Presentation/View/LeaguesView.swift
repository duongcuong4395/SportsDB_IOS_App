//
//  LeaguesView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

struct LeaguesView: View {
    var leagues: [League]
    var badgeImageSizePerLeague: (width: CGFloat, height: CGFloat)
    var tappedLeague: (League) -> Void
    
    var body: some View {
        ForEach(leagues, id: \.idLeague) { league in
            VStack {
                LeagueItemView(league: league, badgeImageSize: badgeImageSizePerLeague)
            }
            .onTapGesture {
                tappedLeague(league)
            }
        }
    }
}

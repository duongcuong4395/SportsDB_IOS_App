//
//  ListLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

struct ListLeagueRouteView: View {
    //@EnvironmentObject var leagueListVM: LeagueListViewModel
    
    var leagues: [League]
    var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    var badgeImageSizePerLeague: (width: CGFloat, height: CGFloat)
    var tappedLeague: (League) -> Void
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    LeaguesView(leagues: leagues, badgeImageSizePerLeague: badgeImageSizePerLeague, tappedLeague: tappedLeague)
                }
            }
        }
    }
}

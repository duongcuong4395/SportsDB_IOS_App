//
//  LeagueItemView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

struct LeagueItemView: View {
    var league: League
    
    var badgeImageSize: (width: CGFloat, height: CGFloat)
    
    var body: some View {
        KFImage(URL(string: league.badge ?? ""))
            .placeholder({ progress in
                ProgressView()
                /*
                Image("Sports")
                    .resizable()
                    .scaledToFill()
                    //.clipShape(Circle())
                 */
            })
            .resizable()
            .scaledToFill()
            .frame(width: badgeImageSize.width, height: badgeImageSize.height)
            .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
            
        Text(league.leagueName ?? "")
            .font(.caption.bold())
        Text(league.currentSeason ?? "")
            .font(.caption2)
    }
}

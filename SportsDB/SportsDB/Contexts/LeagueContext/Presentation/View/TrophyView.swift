//
//  TrophyView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

struct TrophyView: View {
    var league: League
    
    var body: some View {
        VStack {
            KFImage(URL(string: league.trophy ?? ""))
                .placeholder { progress in
                    Image("trophy_symbol")
                        .resizable()
                        .scaledToFill()
                        .fadeInEffect(duration: 100, isLoop: true)
                }
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                .fadeInEffect(duration: 1)
            
        }
    }
    
}

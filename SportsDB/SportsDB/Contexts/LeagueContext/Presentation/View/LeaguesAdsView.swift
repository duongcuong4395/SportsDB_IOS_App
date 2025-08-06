//
//  LeaguesAdsView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

struct LeaguesAdsView: View {
    var league: League
    
    var column: [GridItem] = [GridItem(), GridItem()]
    var body: some View {
        VStack {
            KFImage(URL(string: league.banner ?? ""))
                .placeholder { progress in
                    //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    ProgressView()
                }
                .resizable()
                .scaledToFit()
                //.frame(width: UIScreen.main.bounds.width - 10, height: 100)
                //.padding()
            
            LazyVGrid(columns: column) {
                KFImage(URL(string: league.fanart1 ?? ""))
                    .placeholder { progress in
                        //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                KFImage(URL(string: league.fanart2 ?? ""))
                    .placeholder { progress in
                        //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                KFImage(URL(string: league.fanart3 ?? ""))
                    .placeholder { progress in
                        //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                
                KFImage(URL(string: league.fanart4 ?? ""))
                    .placeholder { progress in
                        //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                
            }
            //.padding()
            
            KFImage(URL(string: league.poster ?? ""))
                .placeholder { progress in
                    //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    ProgressView()
                }
                .resizable()
                .scaledToFit()
                //.frame(width: UIScreen.main.bounds.width - 10, height: 500)
        }
    }
}

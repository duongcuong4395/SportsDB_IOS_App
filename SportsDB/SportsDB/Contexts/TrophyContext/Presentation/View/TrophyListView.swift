//
//  TrophyListView.swift
//  SportsDB
//
//  Created by Macbook on 3/6/25.
//

import SwiftUI
import Kingfisher
struct TrophyListView: View {
    //var trophies: [Trophy]
    var trophyGroup: [TrophyGroup]
    var column: [GridItem] = [GridItem()]
    
    var column2: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                LazyVGrid(columns: column) {
                    
                    ForEach(trophyGroup, id: \.id) { group in
                        HStack{
                            KFImage(URL(string: group.honourArtworkLink))
                                .placeholder { progress in
                                    //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                                    ProgressView()
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width / 3)
                            VStack {
                                Text(group.title)
                                    .font(.body.bold())
                                ScrollView(showsIndicators: false) {
                                    LazyVGrid(columns: column2) {
                                        ForEach(group.listSeason, id: \.self) { season in
                                            Text(season)
                                                .font(.caption2.bold())
                                        }
                                    }
                                    
                                }
                            }
                            .frame(maxHeight: 100)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}


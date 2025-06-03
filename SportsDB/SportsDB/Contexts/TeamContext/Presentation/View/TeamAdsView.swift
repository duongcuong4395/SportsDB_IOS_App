//
//  TeamAdsView.swift
//  SportsDB
//
//  Created by Macbook on 3/6/25.
//

import SwiftUI
import Kingfisher
struct TeamAdsView: View {
    var team: Team
    
    var column: [GridItem] = [GridItem(), GridItem()]
    
    var body: some View {
        VStack {
            TitleComponentView(title: "Description")
            Text("\(team.descriptionEN ?? "")")
                .font(.caption)
                .lineLimit(nil)
                .frame(alignment: .leading)
            
            VStack {
                if let logo = team.logo {
                    KFImage(URL(string: logo))
                        .placeholder { progress in
                            //LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width - 10, height: 100)
                }
                
                
                
                LazyVGrid(columns: column) {
                    if let fanart1 = team.fanart1 {
                        KFImage(URL(string: fanart1))
                            .placeholder { progress in
                                // LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                                ProgressView()
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(height: 100)
                    }
                    if let fanart2 = team.fanart2 {
                        KFImage(URL(string: fanart2))
                            .placeholder { progress in
                                // LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                                ProgressView()
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(height: 100)
                    }
                    
                    if let fanart3 = team.fanart3 {
                        KFImage(URL(string: fanart3))
                            .placeholder { progress in
                                // LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                                ProgressView()
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(height: 100)
                    }
                    
                    if let fanart4 = team.fanart4 {
                        KFImage(URL(string: fanart4))
                            .placeholder { progress in
                                // LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                                ProgressView()
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(height: 100)
                    }
                    
                }
                if let banner = team.banner {
                    KFImage(URL(string: banner))
                        .placeholder { progress in
                            // LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}

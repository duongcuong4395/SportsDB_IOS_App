//
//  TeamDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 2/6/25.
//

import SwiftUI
import Kingfisher
import GeminiAI
import GoogleGenerativeAI

struct TeamDetailRouteView: View {
    var team: Team
    
    var body: some View {
        VStack {
            // MARK: Header
            TeamDetailRouteHeaderView()
            // MARK: Content
            TeamDetailRouteContentView(team: team)
        }
        .background(
            KFImage(URL(string: team.fanart1 ?? ""))
                .placeholder { progress in
                    // LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    ProgressView()
                }
                //.resizable()
                //.scaledToFill()
                //.frame(height: 100)
                .opacity(0.15)
                .ignoresSafeArea(.all)
        )
    }
}

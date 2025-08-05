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
                    ProgressView()
                }
                .opacity(0.1)
                .ignoresSafeArea(.all)
        )
    }
}

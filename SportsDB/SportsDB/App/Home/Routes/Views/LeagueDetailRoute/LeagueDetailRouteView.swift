//
//  LeagueDetailView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI
import Kingfisher

protocol RouteMenu: CaseIterable {
    var title: String { get }
    var icon: String { get }
    var color: Color { get }
}

struct LeagueDetailRouteView: View {
    @EnvironmentObject var leagueDetailVM: LeagueDetailViewModel
    
    var body: some View {
        if let league = leagueDetailVM.league {
            VStack {
                // MARK: Header
                LeagueDetailRouteHeaderView(league: league)
                
                // MARK: Content
                LeagueDetailRouteContentView(league: league)
            }
            .background {
                KFImage(URL(string: league.poster ?? ""))
                    .placeholder { progress in
                        ProgressView()
                    }
                    .opacity(0.1)
                    .ignoresSafeArea(.all)
            }
        }
    }
}











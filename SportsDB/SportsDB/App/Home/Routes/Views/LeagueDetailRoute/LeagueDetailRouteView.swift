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
    
    var leagueID: String
    @State private var selectedTab = 0
    
    var body: some View {
        if let league = leagueDetailVM.league {
            VStack {
                // MARK: Header
                LeagueDetailRouteHeaderView(league: league, selectedTab: $selectedTab)
                
                // MARK: Content
                LeagueDetailRouteContentView(league: league, leagueID: leagueID, selectedTab: $selectedTab)
                    
            }
            
            .background {
                KFImage(URL(string: league.poster ?? ""))
                    .placeholder { progress in
                        ProgressView()
                    }
                    .opacity(0.5)
                    .ignoresSafeArea(.all)
            }
             
        }
    }
}











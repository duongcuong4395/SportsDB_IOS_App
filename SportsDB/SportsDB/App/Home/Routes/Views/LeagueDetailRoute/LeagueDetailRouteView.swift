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
            RouteGenericView(
                headerView: LeagueDetailRouteHeaderView(league: league)
                , contentView: LeagueDetailRouteContentView(league: league)
                , backgroundURLLink: league.poster)
        }
    }
}




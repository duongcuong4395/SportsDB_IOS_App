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


struct RouteGenericView<HeaderView: View, ContentView: View>: View {
    
    private var headerView: HeaderView
    private var contentView: ContentView
    private var backgroundURLLink: String?
    
    init(headerView: HeaderView, contentView: ContentView, backgroundURLLink: String? = nil) {
        self.headerView = headerView
        self.contentView = contentView
        self.backgroundURLLink = backgroundURLLink
    }
    
    var body: some View {
        if let backgroundURLLink {
            VStack {
                headerView
                contentView
            }
            .backgroundOfRouteView(with: backgroundURLLink)
        } else {
            VStack {
                headerView
                contentView
            }
        }
    }
}










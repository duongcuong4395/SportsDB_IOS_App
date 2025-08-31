//
//  RouteGenericView.swift
//  SportsDB
//
//  Created by Macbook on 30/8/25.
//

import SwiftUI

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
            .padding(.bottom, 45)
            .backgroundOfRouteView(with: backgroundURLLink)
        } else {
            VStack {
                headerView
                contentView
            }
            .padding(.bottom, 45)
        }
    }
}

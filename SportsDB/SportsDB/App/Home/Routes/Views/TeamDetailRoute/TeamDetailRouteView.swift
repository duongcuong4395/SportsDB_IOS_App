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
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    
    var body: some View {
        VStack {
            // MARK: Header
            TeamDetailRouteHeaderView()
            
            // MARK: Content
            TeamDetailRouteContentView()
        }
        .backgroundOfRouteView(with: teamDetailVM.teamSelected?.fanart1 ?? "")
    }
}

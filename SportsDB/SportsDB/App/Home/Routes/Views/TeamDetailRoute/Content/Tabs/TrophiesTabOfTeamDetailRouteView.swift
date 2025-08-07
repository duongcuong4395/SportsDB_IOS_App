//
//  TrophiesTabOfTeamDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 7/8/25.
//

import SwiftUI

struct TrophiesTabOfTeamDetailRouteView: View {
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    var body: some View {
        VStack {
            if trophyListVM.trophyGroups.count > 0 {
                TrophyListView(trophyGroup: trophyListVM.trophyGroups)
            }
        }
        .padding(.vertical)
    }
}

//
//  LikeRouteView.swift
//  SportsDB
//
//  Created by Macbook on 12/8/25.
//

import SwiftUI

struct LikeRouteView: View {
    @EnvironmentObject var manageLikeRouteVM: ManageLikeRouteViewModel
    
    var body: some View {
        RouteGenericView(
            headerView: LikeRouteHeaderView()
            , contentView: LikeRouteContentView())
        .onAppear {
            manageLikeRouteVM.loadLikedEvents()
        }
        .onChange(of: manageLikeRouteVM.eventSwiftDataVM.events) { _, _ in
            manageLikeRouteVM.loadLikedEvents()
        }
        .alert("Remove from Favorites", isPresented: $manageLikeRouteVM.showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let event = manageLikeRouteVM.eventToDelete {
                    manageLikeRouteVM.handleToggleLike(event)
                }
            }
        } message: {
            Text("Are you sure you want to remove this event from your favorites?")
        }
    }
}

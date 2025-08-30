//
//  LikeRouteHeaderView.swift
//  SportsDB
//
//  Created by Macbook on 30/8/25.
//

import SwiftUI

struct LikeRouteHeaderView: View {
    @EnvironmentObject var manageLikeRouteVM: ManageLikeRouteViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                if manageLikeRouteVM.isSelectionMode {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        manageLikeRouteVM.resetSelectionMode()
                        manageLikeRouteVM.resetEventsSelected()
                    }
                } else {
                    sportRouter.pop()
                }
            }) {
                Image(systemName: manageLikeRouteVM.isSelectionMode ? "xmark" : "chevron.left")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            HStack(spacing: 8) {
                Image(systemName: manageLikeRouteVM.events.count > 0 ? "heart.fill" : "heart")
                    .font(.body)
                    .foregroundColor(manageLikeRouteVM.events.count > 0 ? .red : .primary)
                
                Text("Favorites")
                    .font(.body.bold())
                
                if !manageLikeRouteVM.events.isEmpty {
                    Text("(\(manageLikeRouteVM.events.count))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .contentTransition(.numericText())
                }
            }
            .onTapGesture {
                if !manageLikeRouteVM.isSelectionMode {
                    sportRouter.pop()
                }
            }
            
            Spacer()
            
            if !manageLikeRouteVM.events.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        manageLikeRouteVM.toggleSelectionMode()
                        manageLikeRouteVM.resetEventsSelected()
                    }
                }) {
                    Image(systemName: manageLikeRouteVM.isSelectionMode ?  "checkmark.circle.fill" : "checklist")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                }
            }
        }
        .padding(.horizontal, 16)
        .backgroundOfRouteHeaderView(with: 70)
    }
}

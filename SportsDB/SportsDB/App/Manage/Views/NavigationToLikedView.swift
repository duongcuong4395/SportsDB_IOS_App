//
//  NavigationToLikedView.swift
//  SportsDB
//
//  Created by Macbook on 1/9/25.
//

import SwiftUI

struct NavigationToLikedView: View {
    @EnvironmentObject var eventSwiftDataVM: EventSwiftDataViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    @State private var likedCount: Int = 0
    @State private var shouldBounce: Bool = false
    
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                Image(systemName: likedCount > 0 ? "heart.fill" : "heart")
                    .font(.title3)
                    .frame(width: 25, height: 25)
                    
                Text("Favotire")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .backgroundByTheme(for: .Button)
            .onTapGesture {
                if !sportRouter.isAtLike {
                    
                    sportRouter.navigateToLike()
                }
            }
        }
        .padding(.top, 5)
        .overlay(alignment: .topTrailing) {
            Color.clear
                .customBadge(likedCount)
        }
        // Listen to changes in eventSwiftDataVM.events
        .onChange(of: eventSwiftDataVM.events.map(\.like)) { oldValues, newValues in
            let newCount = newValues.filter { $0 }.count
            
            if newCount != likedCount {
                withAnimation(.easeInOut(duration: 0.3)) {
                    likedCount = newCount
                }
                
                // Trigger bounce animation
                triggerBounce()
            }
        }
        .onAppear {
            likedCount = eventSwiftDataVM.getEventsLiked().count
        }
    }
    
    func getNumberEventsLiked() -> Int {
        withAnimation {
            return eventSwiftDataVM.getEventsLiked().count
        }
        
    }
    
    private func triggerBounce() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            shouldBounce = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                shouldBounce = false
            }
        }
    }
}

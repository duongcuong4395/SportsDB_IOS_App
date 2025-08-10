//
//  EventLoadingView.swift
//  SportsDB
//
//  Created by Macbook on 10/8/25.
//

import SwiftUI

struct EventLoadingView: View {
    var body: some View {
        VStack {
            ForEach((1...5).reversed(), id: \.self) { _ in
                EventItemView(isVisible: .constant(false),
                              delay: 0.5,
                              event: getEventExample(),
                              optionView: { event in EmptyView() },
                              tapOnTeam: { event, kind in },
                              eventTapped: { event in })
                .redacted(reason: .placeholder)
                .shimmering()
            }
        }
        .transition(.opacity)
    }
}

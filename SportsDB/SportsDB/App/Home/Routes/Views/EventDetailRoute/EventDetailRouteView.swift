//
//  EventDetailRouteView.swift
//  SportsDB
//
//  Created by Macbook on 20/8/25.
//

import SwiftUI

struct EventDetailRouteView: View {
    @EnvironmentObject var eventDetailVM: EventDetailViewModel
    
    var body: some View {
        VStack {
            // MARK: Header
            EventDetailRouteHeaderView()
            // MARK: Content
            EventDetailRouteContentView()
        }
        .onDisappear{
            eventDetailVM.eventsStatus = .idle
        }
    }
}

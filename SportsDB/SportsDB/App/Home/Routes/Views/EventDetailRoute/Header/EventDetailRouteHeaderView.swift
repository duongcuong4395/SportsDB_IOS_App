//
//  EventDetailRouteHeaderView.swift
//  SportsDB
//
//  Created by Macbook on 20/8/25.
//

import SwiftUI
import Kingfisher

struct EventDetailRouteHeaderView: View {
    @EnvironmentObject var eventDetailVM: EventDetailViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                backRoute()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
            })
            
            switch eventDetailVM.eventsStatus {
            case .success(data: let events):
                let event = events[0]
                HStack {
                    KFImage(URL(string: event.thumb ?? ""))
                        .resizable()
                        .scaledToFit()
                    VStack {
                        Text(event.eventName ?? "")
                            .font(.body.bold())
                        //Text(event.leagueName ?? "")
                          //  .font(.caption)
                    }
                    
                    Spacer()
                }
            default:
                EmptyView()
            }
            if let event = eventDetailVM.eventSelected {
                HStack(spacing: 5) {
                    KFImage(URL(string: event.thumb ?? ""))
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                    VStack {
                        Text(event.eventName ?? "")
                            .font(.caption.bold())
                    }
                }
            }
            Spacer()
        }
        //.backgroundOfRouteHeaderView(with: 70)
        .backgroundByTheme(for: .Header(height: 70))
    }
    
    func backRoute() {
        eventDetailVM.eventsStatus = .idle
        sportRouter.pop()
    }
}

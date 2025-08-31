//
//  EventsGenericView.swift
//  SportsDB
//
//  Created by Macbook on 31/8/25.
//

import SwiftUI

struct EventsGenericView<ViewModel: EventsViewModel>: View {
    @EnvironmentObject var manageEventsGenericVM: ManageEventsGenericViewModel
    
    // MARK: - Properties
    @ObservedObject var eventsViewModel: ViewModel
    @State var numbRetry: Int = 0
    var onRetry: () -> Void
    
    var body: some View {
        VStack {
            switch eventsViewModel.eventsStatus {
            case .success:
                eventsList
            case .loading:
                loadingView
            case .idle:
                EmptyView()
            case .failure(error: _):
                errorView
            }
        }
    }
}

// MARK: - View Components
extension EventsGenericView {
    private var eventsList: some View {
        ListEventGenericView(
            events: eventsViewModel.events
            , itemBuilder: ItemBuilderForEventsOfPastLeague()
            , onEvent: { event in
                manageEventsGenericVM.handle(event, eventsViewModel: eventsViewModel)
            })
    }
    
    private var errorView: some View {
        Text("Please return in a few minutes.")
            .font(.caption2.italic())
            .onAppear {
                numbRetry += 1
                guard numbRetry <= 3 else { numbRetry = 0 ; return }
                onRetry()
            }
    }
    
    private var loadingView: some View {
        ProgressView()
               .scaleEffect(1.2)
    }
}


struct ItemBuilderForEventsOfPastLeague: ItemBuilder {
    func buildOptionsBind(for item: Binding<Event>, send: @escaping (ItemEvent<Event>) -> Void) -> AnyView {
        AnyView(
            HStack(spacing: 30) {
                if item.wrappedValue.awayTeam != nil {
                    if item.wrappedValue.homeTeam != "" && item.wrappedValue.awayTeam != "" {
                        if item.wrappedValue.homeScore == nil {
                            buildItemButton(with: .MultiStar) {
                                send(.viewDetail(for: item.wrappedValue))
                            }
                            .foregroundStyle(.blue)
                        }
                    }
                }
                
                
                let now = Date()
                
                if let dateTimeOfMatch = DateUtility.convertToDate(from: item.wrappedValue.timestamp ?? "") {
                    if now < dateTimeOfMatch {
                        buildItemButton(with: item.wrappedValue.notificationStatus == .creeated ? .NotificationOn : .NotificationOff) {
                            send(.toggleNotify(for: item.wrappedValue))
                        }
                    }
                }
                
                if item.wrappedValue.video?.isEmpty == false {
                    buildItemButton(with: .openVideo) {
                        send(.openVideo(for: item.wrappedValue))
                    }
                }
                buildItemButton(with: item.wrappedValue.like ? .HeartFill : .Heart) {
                    send(.toggleLike(for: item.wrappedValue))
                }
            }
        )
    }
    
    func buildOptions(for item: Event, send: @escaping (ItemEvent<Event>) -> Void) -> AnyView {
        AnyView(
            HStack(spacing: 30) {
                if item.awayTeam != nil {
                    if item.homeTeam != "" && item.awayTeam != "" {
                        if item.homeScore == nil {
                            buildItemButton(with: .MultiStar) {
                                send(.viewDetail(for: item))
                            }
                            .foregroundStyle(.blue)
                        }
                    }
                }
                
                
                let now = Date()
                
                if let dateTimeOfMatch = DateUtility.convertToDate(from: item.timestamp ?? "") {
                    if now < dateTimeOfMatch {
                        buildItemButton(with: (item.notificationStatus == .creeated || item.notificationStatus == .hasRead) ? .NotificationOn : .NotificationOff) {
                            send(.toggleNotify(for: item))
                        }
                    }
                }
                
                if item.video?.isEmpty == false {
                    buildItemButton(with: .openVideo) {
                        send(.openVideo(for: item))
                    }
                }
                buildItemButton(with: item.like ? .HeartFill : .Heart) {
                    send(.toggleLike(for: item))
                }
            }
        )
    }
    
    typealias T = Event
    
    
}

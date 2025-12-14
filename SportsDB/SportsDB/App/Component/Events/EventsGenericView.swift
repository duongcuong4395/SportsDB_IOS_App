//
//  EventsGenericView.swift
//  SportsDB
//
//  Created by Macbook on 31/8/25.
//

import SwiftUI

@MainActor
protocol GeneralEventManagement: ObservableObject {
    var eventsStatus: ModelsStatus<[Event]> { get set }
    var events: [Event] { get }
    func updateEvent(from oldItem: Event, with newItem: Event)
}

extension GeneralEventManagement {
    func updateEvent(from oldItem: Event, with newItem: Event) {
        self.eventsStatus = eventsStatus.updateElement(where: { oldEvent in
            oldEvent.idEvent == oldItem.idEvent
        }, with: newItem)
    }
    
    func findEvent(with eventID: String) -> Event? {
        self.eventsStatus.data?.first(where: { $0.idEvent == eventID })
    }
    
    func toggleLikeOnUI(at eventID: String, by like: Bool) {
        guard var event = findEvent(with: eventID) else { return }
        
        event.like = like
        updateEvent(from: event, with: event)
    }
    
    func toggleNotificationOnUI(at eventID: String, by status: NotificationStatus) {
        guard var event = findEvent(with: eventID) else { return }
        
        event.notificationStatus = status
        updateEvent(from: event, with: event)
    }
    
    func resetAll() {
        self.eventsStatus = .idle
    }
}


struct EventsGenericView<ViewModel: GeneralEventManagement>: View {
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
                //loadingView
                getExampleView()
            case .idle:
                EmptyView()
            case .failure(error: _):
                errorView
            }
        }
    }
    
    @ViewBuilder
    func getExampleView() -> some View {
        let event = getEventExample()
        VStack {
            ForEach(0 ..< 3) {_ in
                EventItemGenericView(
                    event: event
                    , isVisible: .constant(true)
                    , delay: 0.01
                    , itemBuilder: ItemBuilderForEvent()
                    , onEvent: { ev in })
                    .redacted(reason: .placeholder)
                    .backgroundByTheme(for: .Button(cornerRadius: .roundedCorners))
            }
        }
    }
}

// MARK: - View Components
extension EventsGenericView {
    private var eventsList: some View {
        ListEventGenericView(
            events: eventsViewModel.events
            , itemBuilder: ItemBuilderForEvent()
            , onEvent: { event in
                manageEventsGenericVM.handle(event, eventsViewModel: eventsViewModel)
            })
    }
    
    private var errorView: some View {
        VStack {
            if numbRetry <= 3 {
                loadingView
            } else {
                Text("Please return in a few minutes.")
                    .font(.caption2.italic())
                    .onTapGesture {
                        numbRetry = 0
                        onRetry()
                    }
            }
        }
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

struct ItemBuilderForEvent: ItemBuilder {
    
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

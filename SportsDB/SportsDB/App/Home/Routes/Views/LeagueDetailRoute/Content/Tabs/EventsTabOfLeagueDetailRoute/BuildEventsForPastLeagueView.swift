//
//  BuildEventsForPastLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 8/8/25.
//

import SwiftUI

struct BuildEventsForPastLeagueView: View, SelectTeamDelegate, EventOptionsViewDelegate {
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var sportRouter: SportRouter
    @EnvironmentObject var eventListVM: EventListViewModel
    
    @EnvironmentObject var eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel
    
    @State var numbRetry: Int = 0
    
    let onRetry: () -> Void
    
    var body: some View {
        
        switch eventsRecentOfLeagueVM.eventsStatus {
        case .idle:
            EmptyView()
        case .loading:
            Text("Progressing...")
        case .success(data: let models):
            
            ListEventGenericView(
                events: eventsRecentOfLeagueVM.events
                , itemBuilder: ItemBuilderForEventsOfPastLeague()
                , onEvent: { event in
                    handle(event)
                })
            
            /*
            ListEventView(
                events: eventsRecentOfLeagueVM.events,
                optionEventView: getEventOptionsView,
                tapOnTeam: tapOnTeam,
                eventTapped: { event in
                    
                })
            */
            
        case .failure(error: let error):
            Text("Please return in a few minutes.")
                .font(.caption2.italic())
                .onAppear{
                    numbRetry += 1
                    guard numbRetry <= 3 else { return }
                    onRetry()
                }
        }
        
    }
    
    func handle(_ event: ItemEvent<Event>) {
        switch event {
        case .toggleLike(for: let event) :
            print("=== toggle like event:", event.eventName ?? "")
            var newEvent = event
            newEvent.like.toggle()
            print("=== newItem like", newEvent.like)
            eventsRecentOfLeagueVM.updateItem(from: event, with: newEvent)
            /*
            _ = eventsRecentOfLeagueVM.eventsStatus.updateElement(where: { oldEvent in
                oldEvent.idEvent == event.idEvent
            }, with: newEvent)
             */
        default: return
        }
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
                        buildItemButton(with: .NotificationOn) {
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
                        buildItemButton(with: .NotificationOn) {
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

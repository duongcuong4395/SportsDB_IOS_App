//
//  BuildEventsForPastLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 8/8/25.
//

import SwiftUI

@MainActor
protocol EventsViewModel: ObservableObject {
    var eventsStatus: ModelsStatus<[Event]> { get set }
    var events: [Event] { get }
}

extension EventsViewModel {
    func updateEvent(from oldItem: Event, with newItem: Event) {
        self.eventsStatus = eventsStatus.updateElement(where: { oldEvent in
            oldEvent.idEvent == oldItem.idEvent
        }, with: newItem)
    }
    
    func resetAll() {
        self.eventsStatus = .idle
    }
    
}

struct EventsGenericView<ViewModel: EventsViewModel>: View {
    
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    @EnvironmentObject var notificationListVM: NotificationListViewModel
    @EnvironmentObject var eventSwiftDataVM: EventSwiftDataViewModel
    
    @EnvironmentObject var sportRouter: SportRouter
    
    
    @ObservedObject var eventsViewModel: ViewModel
    
    @State var numbRetry: Int = 0
    var onRetry: () -> Void
    
    var body: some View {
        VStack {
            switch eventsViewModel.eventsStatus {
            case .success(data: _):
                ListEventGenericView(
                    events: eventsViewModel.events
                    , itemBuilder: ItemBuilderForEventsOfPastLeague()
                    , onEvent: { event in
                        handle(event)
                    })
            case .loading:
                ProgressView()
            case .idle:
                EmptyView()
            case .failure(error: _):
                Text("Please return in a few minutes.")
                    .font(.caption2.italic())
                    .onAppear {
                        numbRetry += 1
                        guard numbRetry <= 3 else { numbRetry = 0 ; return }
                        onRetry()
                    }
            }
        }
        
            
    }
    
    func handle(_ event: ItemEvent<Event>) {
        switch event {
        case .toggleLike(for: let event) :
            onToggleLikeEvent(event)
        case .onApear(for: let event):
            onApearEvent(event)
        case .tapOnTeam(for: let event, with: let kindTeam):
            onTapOnTeam(for: event, with: kindTeam)
        case .toggleNotify(for: let event):
            toggleNotification(event)
        default: return
        }
    }
    
    func onApearEvent(_ event: Event) {
        hasNotification(event) { event in
            hasLike(event)
        }
    }
    
    func hasLike(_ event: Event) {
        let isEventExists = eventSwiftDataVM.isEventExists(idEvent: event.idEvent, eventName: event.eventName)
        guard let eventData = isEventExists.event else { return }
        
        var newEvent = event
        newEvent.like = eventData.like
        eventsViewModel.updateEvent(from: event, with: newEvent)
    }
    
    func hasNotification(_ event: Event, completion: @escaping (Event) -> Void) {
        let hasNotification = notificationListVM.hasNotification(for: event.idEvent ?? "")
        var newEvent = event
        newEvent.notificationStatus = hasNotification ? .creeated : .idle
        eventsViewModel.updateEvent(from: event, with: newEvent)
        completion(newEvent)
    }
    
    func toggleNotification(_ event: Event) {
        Task {
            let isEventSwiftDataExists = eventSwiftDataVM.isEventExists(idEvent: event.idEvent, eventName: event.eventName)
            
            let notification = await notificationListVM.getNotification(for: event.idEvent ?? "")
            guard let notification = notification else {
                guard let noti = event.asNotificationItem else { return }
                await notificationListVM.addNotification(noti)
                print("=== noti.add",  event.eventName ?? "")
                var newEvent = event
                newEvent.notificationStatus = .creeated
                eventsViewModel.updateEvent(from: event, with: newEvent)
                
                // FOR SwiftData
                guard let eventSwiftData = isEventSwiftDataExists.event else {
                    Task {
                        await eventSwiftDataVM.addEvent(event: newEvent.toEventSwiftData(with: .creeated))
                    }
                    return }
                eventSwiftData.notificationStatus = NotificationStatus.creeated.rawValue
                try MainDB.shared.mainContext.save()
                return
            }
            
            print("=== noti.remove",  event.eventName ?? "")
            await notificationListVM.removeNotification(id: notification.id)
            var newEvent = event
            newEvent.notificationStatus = .idle
            eventsViewModel.updateEvent(from: event, with: newEvent)
            
            // FOR SwiftData
            guard let eventSwiftData = isEventSwiftDataExists.event else {
                Task {
                    await eventSwiftDataVM.addEvent(event: newEvent.toEventSwiftData(with: .idle))
                }
                return }
            eventSwiftData.notificationStatus = NotificationStatus.idle.rawValue
            try MainDB.shared.mainContext.save()
        }
    }
    
    func toggleLikeEvent(_ event: Event) {
        let isEventExists =  eventSwiftDataVM.isEventExists(idEvent: event.idEvent, eventName: event.eventName)
        
        guard let eventData = isEventExists.event else {
            Task {
                var newEvent = event
                newEvent.like = true
                eventsViewModel.updateEvent(from: event, with: newEvent)
                await eventSwiftDataVM.addEvent(event: newEvent.toEventSwiftData(with: .idle))
            }
            return }
        eventData.like.toggle()
        
        var newEvent = event
        newEvent.like = eventData.like
        eventsViewModel.updateEvent(from: event, with: newEvent)
        
        Task {
            try MainDB.shared.mainContext.save()
        }
    }
    
    
    
    func onToggleLikeEvent(_ event: Event) {
        toggleLikeEvent(event)
    }
}

extension EventsGenericView {
    
    @MainActor
    func onTapOnTeam(for event: Event, with kindTeam: KindTeam) {
        Task {
            await resetWhenTapTeam()
        }
        
        withAnimation {
            
            let homeVSAwayTeam = event.eventName?.split(separator: " vs ")
            let homeTeam = String(homeVSAwayTeam?[0] ?? "")
            let awayTeam = String(homeVSAwayTeam?[1] ?? "")
            let team: String = kindTeam == .AwayTeam ? awayTeam : homeTeam
            let teamID: String = kindTeam == .AwayTeam ? event.idAwayTeam ?? "" : event.idHomeTeam ?? ""
            if !sportRouter.isAtTeamDetail() {
                sportRouter.navigateToTeamDetail()
            }
            selectTeam(by: team)
            
        }
    }
    
    @MainActor
    func resetWhenTapTeam() async {
        withAnimation(.easeInOut(duration: 0.5)) {
            //teamDetailVM.teamSelected = nil
            trophyListVM.resetTrophies()
            playerListVM.resetPlayersByLookUpAllForaTeam()
            teamDetailVM.resetEquipment()
            //eventListVM.resetEventsOfTeamForNextAndPrevious()
        }
        return
    }
    
    @MainActor
    func selectTeam(by team: String) {
        Task {
            await teamListVM.searchTeams(teamName: team)
            guard teamListVM.teamsBySearch.count > 0 else { return }
            teamDetailVM.setTeam(by: teamListVM.teamsBySearch[0])
            guard let team = teamDetailVM.teamSelected else { return }
            
            eventsOfTeamByScheduleVM.selectTeam(by: team)
            
            
            await playerListVM.lookupAllPlayers(teamID: team.idTeam ?? "")
            
            await teamDetailVM.lookupEquipment(teamID: team.idTeam ?? "")
            
            getPlayersAndTrophies(by: team)
            
        }
    }
    
    @MainActor
    func getPlayersAndTrophies(by team: Team) {
        Task {
            let(players, trophies) = try await team.fetchPlayersAndTrophies()
            trophyListVM.setTrophyGroup(by: trophies)
            getMorePlayer(players: players)
        }
    }
    
    @MainActor
    func getMorePlayer(players: [Player]) {
        let cleanedPlayers = players.filter { otherName in
            !playerListVM.playersByLookUpAllForaTeam.contains { fullName in
                let fulName = (fullName.player ?? "").replacingOccurrences(of: "-", with: " ")
                
                return fulName.lowercased().contains(otherName.player?.lowercased() ?? "")
            }
        }
        
        DispatchQueueManager.share.runOnMain {
            playerListVM.playersByLookUpAllForaTeam.append(contentsOf: cleanedPlayers)
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

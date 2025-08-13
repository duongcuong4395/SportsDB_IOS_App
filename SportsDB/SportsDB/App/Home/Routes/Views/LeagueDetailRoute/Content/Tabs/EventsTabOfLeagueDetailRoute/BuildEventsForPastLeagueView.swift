//
//  BuildEventsForPastLeagueView.swift
//  SportsDB
//
//  Created by Macbook on 8/8/25.
//

import SwiftUI
import SwiftData

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
        
    // MARK: - Environment Objects
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var teamListVM: TeamListViewModel
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    @EnvironmentObject var notificationListVM: NotificationListViewModel
    @EnvironmentObject var eventSwiftDataVM: EventSwiftDataViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
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
    
    // MARK: - View Components
    private var eventsList: some View {
        ListEventGenericView(
            events: eventsViewModel.events
            , itemBuilder: ItemBuilderForEventsOfPastLeague()
            , onEvent: { event in
                handle(event)
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

// MARK: - Event Handling
extension EventsGenericView {
    func handle(_ event: ItemEvent<Event>) {
        switch event {
        case .toggleLike(for: let event) :
            onToggleLikeEvent(event)
            //Task { await handleToggleLike(event) }
        case .onApear(for: let event):
            onApearEvent(event)
            //Task { await handleEventAppear(event) }
        case .tapOnTeam(for: let event, with: let kindTeam):
            onTapOnTeam(for: event, with: kindTeam)
        case .toggleNotify(for: let event):
            toggleNotification(event)
            //Task { await handleToggleNotification(event) }
        default: return
        }
    }
    
    
    
    
    
     func onToggleLikeEvent(_ event: Event) {
         toggleLikeEvent(event)
     }
     
    func toggleLikeEvent(_ event: Event) {
        Task {
            let isEventExists = await eventSwiftDataVM.getEvent(by: event.idEvent, or: event.eventName)
            
            guard let eventData = isEventExists else {
                Task {
                    var newEvent = event
                    newEvent.like = true
                    eventsViewModel.updateEvent(from: event, with: newEvent)
                    let _ = await eventSwiftDataVM.addEvent(event: newEvent.toEventSwiftData(with: .idle))
                }
                return }
            
            let eventDataUpdate = try await eventSwiftDataVM.toggleLike(eventData)
            
            var newEvent = event
            newEvent.like = eventDataUpdate.like
            eventsViewModel.updateEvent(from: event, with: newEvent)
            
            
        }
        
    }
    
    
    func onApearEvent(_ event: Event) {
        hasNotification(event) { event in
            hasLike(event)
        }
    }
    
    func hasLike(_ event: Event) {
        Task {
            let isEventExists = await eventSwiftDataVM.getEvent(by: event.idEvent, or: event.eventName)
            guard let eventData = isEventExists else {
                
                return }
            
            print("=== event data:", event.eventName, eventData.like)
            var newEvent = event
            newEvent.like = eventData.like
            eventsViewModel.updateEvent(from: event, with: newEvent)
        }
        
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
            let isEventSwiftDataExists = await eventSwiftDataVM.getEvent(by: event.idEvent, or: event.eventName)
            
            let notification = await notificationListVM.getNotification(for: event.idEvent ?? "")
            guard let notification = notification else {
                guard let noti = event.asNotificationItem else { return }
                let _ = await notificationListVM.addNotification(noti)
                print("=== noti.add",  event.eventName ?? "")
                var newEvent = event
                newEvent.notificationStatus = .creeated
                try await eventSwiftDataVM.setNotification(newEvent, by: .creeated)
                eventsViewModel.updateEvent(from: event, with: newEvent)
                
                
                /*
                // FOR SwiftData
                guard let eventSwiftData = isEventSwiftDataExists else {
                    Task {
                        await eventSwiftDataVM.addEvent(event: newEvent.toEventSwiftData(with: .creeated))
                    }
                    return }
                eventSwiftData.notificationStatus = NotificationStatus.creeated.rawValue
                try MainDB.shared.mainContext.save()
                */
                return
            }
            
            print("=== noti.remove",  event.eventName ?? "")
            await notificationListVM.removeNotification(id: notification.id)
            var newEvent = event
            newEvent.notificationStatus = .idle
            
            try await eventSwiftDataVM.setNotification(newEvent, by: .idle)
            eventsViewModel.updateEvent(from: event, with: newEvent)
            
            /*
            // FOR SwiftData
            guard let eventSwiftData = isEventSwiftDataExists else {
                Task {
                    await eventSwiftDataVM.addEvent(event: newEvent.toEventSwiftData(with: .idle))
                }
                return }
            eventSwiftData.notificationStatus = NotificationStatus.idle.rawValue
            try MainDB.shared.mainContext.save()
            */
        }
    }
    
}

// MARK: handleToggleNotification
extension EventsGenericView {
    private func handleToggleNotification(_ event: Event) async {
        let existingEvent = await eventSwiftDataVM.getEvent(by: event.idEvent, or: event.eventName)
        let notification = await notificationListVM.getNotification(for: event.idEvent ?? "")
        
        if notification == nil {
            await addNotification(for: event, existingEvent: existingEvent)
        } else {
            await removeNotification(for: event, existingEvent: existingEvent)
        }
    }
    
    private func addNotification(for event: Event, existingEvent: EventSwiftData?) async {
        guard let notificationItem = event.asNotificationItem else { return }
        
        _ = await notificationListVM.addNotification(notificationItem)
        //guard success else { return }
        
        var updatedEvent = event
        updatedEvent.notificationStatus = .creeated
        eventsViewModel.updateEvent(from: event, with: updatedEvent)
        
        await updateOrCreateEventData(updatedEvent, existingEvent: existingEvent, status: .creeated)
    }
    
    private func removeNotification(for event: Event, existingEvent: EventSwiftData?) async {
        await notificationListVM.removeNotification(id: event.idEvent ?? "")
        
        var updatedEvent = event
        updatedEvent.notificationStatus = .idle
        eventsViewModel.updateEvent(from: event, with: updatedEvent)
        
        await updateOrCreateEventData(updatedEvent, existingEvent: existingEvent, status: .idle)
    }
    
    private func updateOrCreateEventData(_ event: Event, existingEvent: EventSwiftData?, status: NotificationStatus) async {
        if let existingEvent = existingEvent {
            existingEvent.notificationStatus = status.rawValue
            do {
                try MainDB.shared.mainContext.save()
            } catch {
                print("❌ Failed to save notification status: \(error)")
            }
        } else {
            let success = await eventSwiftDataVM.addEvent(event: event.toEventSwiftData(with: status))
            if !success {
                print("❌ Failed to create new event data")
            }
        }
    }
}

// MARK: handleEventAppear
extension EventsGenericView {
    private func handleEventAppear(_ event: Event) async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.updateNotificationStatus(for: event) }
            group.addTask { await self.updateLikeStatus(for: event) }
        }
    }
    
    private func updateLikeStatus(for event: Event) async {
        guard let eventData = await eventSwiftDataVM.getEvent(by: event.idEvent, or: event.eventName) else {
            return
        }
        
        var updatedEvent = event
        updatedEvent.like = eventData.like
        eventsViewModel.updateEvent(from: event, with: updatedEvent)
    }
    
    private func updateNotificationStatus(for event: Event) async {
        let hasNotification = notificationListVM.hasNotification(for: event.idEvent ?? "")
        var updatedEvent = event
        updatedEvent.notificationStatus = hasNotification ? .creeated : .idle
        eventsViewModel.updateEvent(from: event, with: updatedEvent)
    }
}

// MARK: handleToggleLike
extension EventsGenericView {
    private func handleToggleLike(_ event: Event) async {
        let existingEvent = await eventSwiftDataVM.getEvent(by: event.idEvent, or: event.eventName)
            
        if let existingEvent = existingEvent {
            Task {
                let eventDataUpdate = try await eventSwiftDataVM.toggleLike(existingEvent)
                var updatedEvent = event
                updatedEvent.like = eventDataUpdate.like
                eventsViewModel.updateEvent(from: event, with: updatedEvent)
            }
            
        } else {
            var newEvent = event
            newEvent.like = true
            eventsViewModel.updateEvent(from: event, with: newEvent)
            let _ = await eventSwiftDataVM.addEvent(event: newEvent.toEventSwiftData(with: .idle))
        }
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

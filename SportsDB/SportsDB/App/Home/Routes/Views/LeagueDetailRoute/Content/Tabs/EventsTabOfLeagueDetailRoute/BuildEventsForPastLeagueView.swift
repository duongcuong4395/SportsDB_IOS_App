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
    func updateEvent(from oldItem: Event, with newItem: Event)
}

extension EventsViewModel {
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

struct EventsGenericView<ViewModel: EventsViewModel>: View {
        
    // MARK: - Environment Objects
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    @EnvironmentObject var playerListVM: PlayerListViewModel
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    @EnvironmentObject var teamListVM: TeamListViewModel
    //@EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    @EnvironmentObject var notificationListVM: NotificationListViewModel
    @EnvironmentObject var eventSwiftDataVM: EventSwiftDataViewModel
    @EnvironmentObject var sportRouter: SportRouter
    
    @EnvironmentObject var aiManageVM: AIManageViewModel
    @EnvironmentObject var appVM: AppViewModel
    
    @EnvironmentObject var teamSelectionManager: TeamSelectionManager
    
    @EnvironmentObject var eventToggleLikeManager: EventToggleLikeManager
    @EnvironmentObject var eventToggleNotificationManager: EventToggleNotificationManager
    
    // MARK: - Properties
    @Environment(\.openURL) var openURL
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
        case .toggleLike(for: let event):
            Task { try await handleToggleLikeEvent(event) }
        case .tapOnTeam(for: let event, with: let kindTeam):
            Task { try await teamSelectionManager.handleTapOnTeam(by: event, with: kindTeam) }
        case .toggleNotify(for: let event):
            Task { try await handleToggleNotificationEvent(event) }
        case .onApear(for: let event):
            handleEventAppear(event)
        case .viewDetail(for: let event):
            handleViewDetailEvent(event)
        case .openVideo(for: let event):
            openURL(URL(string: "\(event.video ?? "")")!)
        default: return
        }
    }
    
}

// MARK: Handle view Detail Event
extension EventsGenericView {
    func handleViewDetailEvent(_ event: Event) {
        if aiManageVM.aiSwiftData == nil {
            appVM.showDialogView("AI Key", by: AnyView(GeminiAddKeyView()))
        } else {
            appVM.showDialogView("Event Analysis", by: AnyView(EventAIAnalysisView(event: event)))
        }
    }
}



// MARK: Handle Toggle Like Event
extension EventsGenericView {
    func handleToggleLikeEvent(_ event: Event) async throws {
        let newEvent = try await eventSwiftDataVM.setLike(event)
        //eventsViewModel.updateEvent(from: event, with: newEvent)
        
        eventToggleLikeManager.toggleLikeOnUI(at: event.idEvent ?? "", by: newEvent.like)
    }
}

// MARK: Handle Toggle notification Event
extension EventsGenericView {
    func handleToggleNotificationEvent(_ event: Event) async throws {
        let newEvent = await notificationListVM.toggleNotification(event)
        _ = try await eventSwiftDataVM.setNotification(newEvent, by: newEvent.notificationStatus)
        
        eventToggleNotificationManager.toggleNotificationOnUI(at: event.idEvent ?? "", by: newEvent.notificationStatus)
        
        //eventsViewModel.updateEvent(from: event, with: newEvent)
    }
}

// MARK: Handle Event Appear
extension EventsGenericView {
    func handleEventAppear(_ event: Event) {
        hasNotification(event) { event in
              hasLike(event)
        }
    }
    
    func hasLike(_ event: Event) {
        Task {
            let isEventExists = await eventSwiftDataVM.getEvent(by: event.idEvent, or: event.eventName)
            guard let eventData = isEventExists else { return }
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
}




import Kingfisher
struct EventAIAnalysisView: View {
    @EnvironmentObject var aiManage: AIManageViewModel
    var event: Event
    
    
    @State var loading: Bool = false
    @State var eventAnalysisDetail: String = ""
    
    var body: some View {
        VStack {
            KFImage(URL(string: event.thumb ?? ""))
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            if loading {
                VStack(alignment: .leading) {
                    ShimmerView()
                         .cornerRadius(5)
                         .frame(height: 10)
                    ShimmerView()
                         .cornerRadius(5)
                         .frame(height: 10)
                    ShimmerView()
                         .cornerRadius(5)
                         .frame(width: UIScreen.main.bounds.width/3, height: 10)
                }
            } else {
                MarkdownTypewriterView(streamText: $eventAnalysisDetail, typingSpeed: .veryFast)
                    .padding(0)
            }
        }
        .padding(0)
        .frame(maxHeight: UIScreen.main.bounds.height / 2)
        .onAppear{
            eventAnalysis()
        }
    }
    
    func eventAnalysis() {
        self.loading = true
        
        let prompt = String(format: TextGen.getText(.promptEvent2vs2Analysis)
               , event.sportName ?? ""
               , event.homeTeam ?? ""
               , event.awayTeam ?? ""
               , event.eventName ?? ""
               , event.leagueName ?? ""
               , event.timestamp ?? ""
               , event.venue ?? ""
               , event.round ?? ""
               , event.season ?? ""
        )

        aiManage.GeminiSend(prompt: prompt, and: true) { streamData, status in
            self.loading = false
            switch status {
            case .NotExistsKey:
                DispatchQueue.main.async {
                    // Append new stream data to existing detail
                    self.eventAnalysisDetail += streamData
                }
                print("=== event.analysis.status", status, streamData)
            case .ExistsKey:
                print("=== event.analysis.status", status, streamData)
            case .SendReqestFail:
                print("=== event.analysis.status", status, streamData)
            case .Success:
                DispatchQueue.main.async {
                    // Append new stream data to existing detail
                    self.eventAnalysisDetail += streamData
                }
            }
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

// MARK: Handle Tap On team
extension EventsGenericView {
    func handleTapOnTeam(by event: Event, with kindTeam: KindTeam) async throws {
        
        
        let teamName = getTeamName(by: event, with: kindTeam)
        
        if let teamSelected = teamDetailVM.teamSelected
            , teamSelected.teamName == teamName {
            return
        }
        
        resetWhenTapTeam()
        try await selectTeam(by: teamName)
    }
    
    func getTeamName(by event: Event, with kindTeam: KindTeam) -> String {
        let homeVSAwayTeam = event.eventName?.split(separator: " vs ")
        let homeTeam = String(homeVSAwayTeam?[0] ?? "")
        let awayTeam = String(homeVSAwayTeam?[1] ?? "")
        let teamName: String = kindTeam == .AwayTeam ? awayTeam : homeTeam
        return teamName
    }
}

// MARK: Select team
extension EventsGenericView {
    
    @MainActor
    func resetWhenTapTeam() {
        teamSelectionManager.resetTeamData()
        /*
        withAnimation(.spring()) {
            //eventsOfTeamByScheduleVM.resetAll()
            //trophyListVM.resetTrophies()
            //playerListVM.resetPlayersByLookUpAllForaTeam()
            //teamDetailVM.resetEquipment()
        }
        */
    }
    
    @MainActor
    func selectTeam(by teamName: String) async throws {
        if let teamSelected = teamDetailVM.teamSelected {
            if teamSelected.teamName != teamName {
                await setTeam(by: teamName)
            }
        } else {
            await setTeam(by: teamName)
        }
       
        guard let team = teamDetailVM.teamSelected else { return }
        if !sportRouter.isAtTeamDetail() {
            sportRouter.navigateToTeamDetail()
        }
        
        
        
        //async let eventsTask: () = getEventsUpcomingAndResults(by: team)
        //async let equipmentsTask: () = getEquipments(by: team.idTeam ?? "")
        async let equipmentsTask: () = teamSelectionManager.fetchEquipments(for: team.idTeam ?? "")
        //async let playersTask: () = getPlayersAndTrophies(by: team)
        async let playersTask: () = await teamSelectionManager.fetchPlayersAndTrophies(for: team)
        async let events: () =  await teamSelectionManager.fetchEvents(for: team)
        _ = await (playersTask, equipmentsTask, events)
    }
    
    func setTeam(by teamName: String) async {
        await teamListVM.searchTeams(teamName: teamName)
        guard teamListVM.teamsBySearch.count > 0 else { return }
        teamDetailVM.setTeam(by: teamListVM.teamsBySearch[0])
        return
    }
    
    
    @MainActor
    func getPlayersAndTrophies(by team: Team) async {
        await playerListVM.lookupAllPlayers(teamID: team.idTeam ?? "")
        let(players, trophies) = await team.fetchPlayersAndTrophies()
        trophyListVM.setTrophyGroup(by: trophies)
        getMorePlayer(players: players)
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


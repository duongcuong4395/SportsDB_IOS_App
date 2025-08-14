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
    
    @EnvironmentObject var aiManageVM: AIManageViewModel
    @EnvironmentObject var appVM: AppViewModel
    
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
        case .toggleLike(for: let event) :
            onToggleLikeEvent(event)
        case .onApear(for: let event):
            onApearEvent(event)
        case .tapOnTeam(for: let event, with: let kindTeam):
            onTapOnTeam(for: event, with: kindTeam)
        case .toggleNotify(for: let event):
            toggleNotification(event)
        case .viewDetail(for: let event):
            print("=== event detail")
            if aiManageVM.aiSwiftData == nil {
                appVM.showDialogView(with: "AI Key", and: AnyView(GeminiAddKeyView()))
            } else {
                print("=== analisys:", event.eventName ?? "")
                appVM.showDialogView(with: "Event Analysis", and: AnyView(EventAIAnalysisView(event: event)))
            }
        case .openVideo(for: let event):
            let link = "\(event.video ?? "")"
            print("=== link: ", link)
            openURL(URL(string: link)!)
        default: return
        }
    }
    
     func onToggleLikeEvent(_ event: Event) {
         toggleLikeEvent(event)
     }
     
    func toggleLikeEvent(_ event: Event) {
        Task {
            let newEvent = try await eventSwiftDataVM.setLike(event)
            DispatchQueue.main.async {
                eventsViewModel.updateEvent(from: event, with: newEvent)
            }
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
    
    func toggleNotification(_ event: Event) {
        Task {
            let newEvent = await notificationListVM.toggleNotification(event)
            _ = try await eventSwiftDataVM.setNotification(newEvent, by: newEvent.notificationStatus)
            eventsViewModel.updateEvent(from: event, with: newEvent)
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
        
        let prompt = """
Bạn là một chuyên gia thể thao với hơn 30 năm kinh nghiệm trong lĩnh vực phân tích và dự đoán kết quả các trận đấu của môn thể thao \(event.sportName ?? ""). Với sự am hiểu sâu sắc về các team (\(event.homeTeam ?? "") , \(event.awayTeam ?? "")), cầu thủ, chiến thuật thi đấu và xu hướng của giải đấu, hãy sử dụng kiến thức phong phú của bạn để tiến hành phân tích chi tiết về sự kiện thể thao \(event.eventName ?? "") trong khuôn khổ Giải đấu \(event.leagueName ?? "").

Sự kiện này sẽ diễn ra vào thời điểm \(event.timestamp ?? "") tại địa điểm \(event.venue ?? ""). Bạn hãy xem xét các yếu tố ảnh hưởng như phong độ hiện tại của các đội, thống kê lịch sử đối đầu, điều kiện thời tiết, cũng như các chấn thương có thể xảy ra với cầu thủ.

Bên cạnh đó, hãy đưa ra dự đoán kết quả cuối cùng của trận đấu trong vòng \(event.round ?? "") của mùa giải \(event.season ?? "") này. Phân tích của bạn sẽ rất có giá trị đối với những người hâm mộ và các nhà đầu tư trong lĩnh vực cá cược thể thao.
"""
        
        print("==== prompt:", prompt)
        
        aiManage.GeminiSend(prompt: prompt, and: true) { streamData, status in
            self.loading = false
            switch status {
            case .NotExistsKey:
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

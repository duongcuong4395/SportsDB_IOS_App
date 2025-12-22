//
//  ManageEventsGenericViewModel.swift
//  SportsDB
//
//  Created by Macbook on 31/8/25.
//

import SwiftUI

@MainActor
class ManageTeamGenericViewModel: ObservableObject {
    private var teamSelectionManager: TeamSelectionManager
    
    init(teamSelectionManager: TeamSelectionManager) {
        self.teamSelectionManager = teamSelectionManager
    }
}

@MainActor
class ManageEventsGenericViewModel: ObservableObject {
    // MARK: - Environment Objects
    private var trophyListVM: TrophyListViewModel
    private var playerListVM: PlayerListViewModel
    private var teamDetailVM: TeamDetailViewModel
    private var teamListVM: TeamListViewModel
    
    private var notificationListVM: NotificationListViewModel
    private var eventSwiftDataVM: EventSwiftDataViewModel
    private var sportRouter: SportRouter
    
    private var aiManageVM: AIManageViewModel
    private var appVM: AppViewModel
    
    private var teamSelectionManager: TeamSelectionManager
    
    private var eventToggleLikeManager: EventToggleLikeManager
    private var eventToggleNotificationManager: EventToggleNotificationManager
    
    
    
    @Environment(\.openURL) var openURL
    
    init(trophyListVM: TrophyListViewModel, playerListVM: PlayerListViewModel, teamDetailVM: TeamDetailViewModel, teamListVM: TeamListViewModel, notificationListVM: NotificationListViewModel, eventSwiftDataVM: EventSwiftDataViewModel, sportRouter: SportRouter, aiManageVM: AIManageViewModel, appVM: AppViewModel, teamSelectionManager: TeamSelectionManager, eventToggleLikeManager: EventToggleLikeManager, eventToggleNotificationManager: EventToggleNotificationManager) {
        self.trophyListVM = trophyListVM
        self.playerListVM = playerListVM
        self.teamDetailVM = teamDetailVM
        self.teamListVM = teamListVM
        self.notificationListVM = notificationListVM
        self.eventSwiftDataVM = eventSwiftDataVM
        self.sportRouter = sportRouter
        self.aiManageVM = aiManageVM
        self.appVM = appVM
        self.teamSelectionManager = teamSelectionManager
        self.eventToggleLikeManager = eventToggleLikeManager
        self.eventToggleNotificationManager = eventToggleNotificationManager
    }
    
    func handle<ViewModel: GeneralEventManagement>(_ event: ItemEvent<Event>, eventsViewModel: ViewModel) {
        switch event {
        case .toggleLike(for: let event):
            Task { try await handleToggleLikeEvent(event) }
        case .tapOnTeam(for: let event, with: let kindTeam):
            Task { try await teamSelectionManager.handleTapOnTeam(by: event, with: kindTeam) }
        case .toggleNotify(for: let event):
            Task { try await handleToggleNotificationEvent(event) }
        case .onApear(for: let event):
            handleEventAppear(event, eventsViewModel: eventsViewModel)
        case .viewDetail(for: let event):
            handleViewDetailEvent(event)
        case .openVideo(for: let event):
            openURL(URL(string: "\(event.video ?? "")")!)
        default: return
        }
    }
}

extension ManageEventsGenericViewModel {
    func handleEventAppear<ViewModel: GeneralEventManagement>(_ event: Event, eventsViewModel: ViewModel) {
        hasNotification(event, eventsViewModel: eventsViewModel) { event in
            self.hasLike(event, eventsViewModel: eventsViewModel)
        }
    }
    
    func hasLike<ViewModel: GeneralEventManagement>(_ event: Event, eventsViewModel: ViewModel) {
        Task {
            let isEventExists = await eventSwiftDataVM.getEvent(by: event.idEvent, or: event.eventName)
            guard let eventData = isEventExists else { return }
            var newEvent = event
            newEvent.like = eventData.like
            eventsViewModel.updateEvent(from: event, with: newEvent)
        }
        
    }
    
    func hasNotification<ViewModel: GeneralEventManagement>(_ event: Event, eventsViewModel: ViewModel, completion: @escaping (Event) -> Void) {
        let hasNotification = notificationListVM.hasNotification(for: event.idEvent ?? "")
        var newEvent = event
        newEvent.notificationStatus = hasNotification ? .creeated : .idle
        eventsViewModel.updateEvent(from: event, with: newEvent)
        completion(newEvent)
    }
}

// MARK: handleToggleNotificationEvent
extension ManageEventsGenericViewModel {
    func handleToggleNotificationEvent(_ event: Event) async throws {
        let newEvent = await notificationListVM.toggleNotification(event)
        await notificationListVM.loadNotifications()
        _ = try await eventSwiftDataVM.setNotification(newEvent, by: newEvent.notificationStatus)
        
        eventToggleNotificationManager.toggleNotificationOnUI(at: event.idEvent ?? "", by: newEvent.notificationStatus)
    }
}

// MARK: handleToggleLikeEvent
extension ManageEventsGenericViewModel {
    func handleToggleLikeEvent(_ event: Event) async throws {
        let newEvent = try await eventSwiftDataVM.setLike(event)
        eventToggleLikeManager.toggleLikeOnUI(at: event.idEvent ?? "", by: newEvent.like)
        await eventSwiftDataVM.loadEvents()
    }
}

// MARK: handleViewDetailEvent
extension ManageEventsGenericViewModel {
    func handleViewDetailEvent(_ event: Event) {
        if let aiSwiftData = aiManageVM.aiSwiftData {
            aiManageVM.testKeyExists(with: "chỉ cần in ra text: hello", and: aiSwiftData.valueItem) { messResult, geminiStatus in
                switch geminiStatus {
                case .Success:
                    self.appVM.showDialogView("Event Analysis", by: AnyView(EventAIAnalysisView(event: event)))
                case .NotExistsKey:
                    self.appVM.showDialogView("AI Key", by: AnyView(GeminiAddKeyView()))
                default:
                    self.appVM.showDialogView("AI Key", by: AnyView(GeminiAddKeyView()))
                }
            }
        } else {
            appVM.showDialogView("AI Key", by: AnyView(GeminiAddKeyView()))
        }
    }
}

import Kingfisher
import MarkdownTypingKit
struct EventAIAnalysisView: View {
    @EnvironmentObject var aiManage: AIManageViewModel
    var event: Event
    
    
    @State var loading: Bool = false
    @State var eventAnalysisDetail: String = ""
    @State private var isTypingComplete: Bool = true
    
    var body: some View {
        VStack {
            KFImage(URL(string: event.thumb ?? ""))
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            
            MarkdownTypewriterView(text: $eventAnalysisDetail, isTypingComplete: $isTypingComplete)
                .typingSpeed(.fast)
                .autoScroll(true)
            
        }
        .padding(0)
        .frame(maxHeight: UIScreen.main.bounds.height / 2)
        .onAppear{
            print("=== Event analysis")
            dump(event)
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

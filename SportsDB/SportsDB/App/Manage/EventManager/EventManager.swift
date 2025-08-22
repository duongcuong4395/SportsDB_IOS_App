//
//  EventManager.swift
//  SportsDB
//
//  Created by Macbook on 20/8/25.
//

import SwiftUI

@MainActor
class EventManager<ViewModel: EventsViewModel>: ObservableObject {
    @Environment(\.openURL) var openURL
    private var eventSwiftDataVM: EventSwiftDataViewModel
    private var teamSelectionManager: TeamSelectionManager
    private var notificationListVM: NotificationListViewModel
    private var aiManageVM: AIManageViewModel
    private var appVM: AppViewModel
    private var eventsViewModel: ViewModel
    
    
    init(eventSwiftDataVM: EventSwiftDataViewModel, teamSelectionManager: TeamSelectionManager, notificationListVM: NotificationListViewModel, aiManageVM: AIManageViewModel, appVM: AppViewModel, eventsViewModel: ViewModel) {
        self.eventSwiftDataVM = eventSwiftDataVM
        self.teamSelectionManager = teamSelectionManager
        self.notificationListVM = notificationListVM
        self.aiManageVM = aiManageVM
        self.appVM = appVM
        self.eventsViewModel = eventsViewModel
    }
    
    func handle(_ event: ItemEvent<Event>, eventsVM: ViewModel) {
        switch event {
        case .toggleLike(for: let event):
            Task { try await handleToggleLikeEvent(event, eventVM: eventsVM) }
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
    
    func handleViewDetailEvent(_ event: Event) {
        if aiManageVM.aiSwiftData == nil {
            appVM.showDialogView("AI Key", by: AnyView(GeminiAddKeyView()))
        } else {
            appVM.showDialogView("Event Analysis", by: AnyView(EventAIAnalysisView(event: event)))
        }
    }
    
    func handleToggleLikeEvent(_ event: Event, eventVM: ViewModel) async throws {
        let newEvent = try await eventSwiftDataVM.setLike(event)
        eventsViewModel.updateEvent(from: event, with: newEvent)
    }
    
    func handleToggleNotificationEvent(_ event: Event) async throws {
        let newEvent = await notificationListVM.toggleNotification(event)
        _ = try await eventSwiftDataVM.setNotification(newEvent, by: newEvent.notificationStatus)
        eventsViewModel.updateEvent(from: event, with: newEvent)
    }
    
    func handleEventAppear(_ event: Event) {
        hasNotification(event) { event in
            self.hasLike(event)
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

@MainActor
class EventToggleLikeManager: ObservableObject {
    private let eventListVM: EventListViewModel
    private let eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    private let eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    private let eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    private let eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel
    
    init(eventListVM: EventListViewModel, eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel, eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel, eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel, eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel) {
        
        self.eventListVM = eventListVM
        self.eventsOfTeamByScheduleVM = eventsOfTeamByScheduleVM
        self.eventsInSpecificInSeasonVM = eventsInSpecificInSeasonVM
        self.eventsPerRoundInSeasonVM = eventsPerRoundInSeasonVM
        self.eventsRecentOfLeagueVM = eventsRecentOfLeagueVM
    }
    
    func toggleLikeOnUI(at eventID: String, by like: Bool) {
        eventsOfTeamByScheduleVM.eventsOfTeamByUpcomingVM.toggleLikeOnUI(at: eventID, by: like)
        eventsOfTeamByScheduleVM.eventsOfTeamByResultsVM.toggleLikeOnUI(at: eventID, by: like)
        
        eventsInSpecificInSeasonVM.toggleLikeOnUI(at: eventID, by: like)
        eventsPerRoundInSeasonVM.toggleLikeOnUI(at: eventID, by: like)
        eventsRecentOfLeagueVM.toggleLikeOnUI(at: eventID, by: like)
    }
}


@MainActor
class EventToggleNotificationManager: ObservableObject {
    private let eventListVM: EventListViewModel
    private let eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    private let eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel
    private let eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel
    private let eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel
    
    init(eventListVM: EventListViewModel, eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel, eventsInSpecificInSeasonVM: EventsInSpecificInSeasonViewModel, eventsPerRoundInSeasonVM: EventsPerRoundInSeasonViewModel, eventsRecentOfLeagueVM: EventsRecentOfLeagueViewModel) {
        
        self.eventListVM = eventListVM
        self.eventsOfTeamByScheduleVM = eventsOfTeamByScheduleVM
        self.eventsInSpecificInSeasonVM = eventsInSpecificInSeasonVM
        self.eventsPerRoundInSeasonVM = eventsPerRoundInSeasonVM
        self.eventsRecentOfLeagueVM = eventsRecentOfLeagueVM
    }
    
    func toggleNotificationOnUI(at eventID: String, by status: NotificationStatus) {
        eventsOfTeamByScheduleVM.eventsOfTeamByUpcomingVM.toggleNotificationOnUI(at: eventID, by: status)
        eventsOfTeamByScheduleVM.eventsOfTeamByResultsVM.toggleNotificationOnUI(at: eventID, by: status)
        
        eventsInSpecificInSeasonVM.toggleNotificationOnUI(at: eventID, by: status)
        eventsPerRoundInSeasonVM.toggleNotificationOnUI(at: eventID, by: status)
        eventsRecentOfLeagueVM.toggleNotificationOnUI(at: eventID, by: status)
    }
}

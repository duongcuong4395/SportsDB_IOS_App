//
//  EventManager.swift
//  SportsDB
//
//  Created by Macbook on 20/8/25.
//

import SwiftUI

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

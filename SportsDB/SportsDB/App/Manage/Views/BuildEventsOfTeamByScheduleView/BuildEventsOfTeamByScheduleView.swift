//
//  BuildEventsOfTeamByScheduleView.swift
//  SportsDB
//
//  Created by Macbook on 7/6/25.
//

import SwiftUI

struct BuildEventsOfTeamByScheduleView: View, EventOptionsViewDelegate, SelectTeamDelegate {
    @EnvironmentObject var eventsOfTeamByScheduleVM: EventsOfTeamByScheduleViewModel
    
    @EnvironmentObject var teamListVM: TeamListViewModel
    
    @EnvironmentObject var teamDetailVM: TeamDetailViewModel
    
    @EnvironmentObject var playerListVM: PlayerListViewModel
    
    @EnvironmentObject var eventListVM: EventListViewModel
    
    @EnvironmentObject var trophyListVM: TrophyListViewModel
    
    @EnvironmentObject var sportRouter: SportRouter
    
    var team: Team
    
    var body: some View {
        EventsOfTeamByScheduleView(
            team: team,
            optionEventView: getEventOptionsView,
            tapOnTeam: { event, kindTeam in
                Task {
                    await resetWhenTapTeam()
                    await tapOnTeamForReplace(by: event, for: kindTeam)
                }
            },
            eventTapped: { event in })
    }
    
    func tapOnTeamForReplace(by event: Event, for kindTeam: KindTeam) async {
        
        withAnimation {
            
            print("=== tapOnHomeTeam.event", event.eventName ?? "", event.homeTeam ?? "", event.idHomeTeam ?? "")
            let homeVSAwayTeam = event.eventName?.split(separator: " vs ")
            let homeTeam = String(homeVSAwayTeam?[0] ?? "")
            let awayTeam = String(homeVSAwayTeam?[1] ?? "")
            let team: String = kindTeam == .AwayTeam ? awayTeam : homeTeam
            //let teamID: String = kindTeam == .AwayTeam ? event.idAwayTeam ?? "" : event.idHomeTeam ?? ""
            
            selectTeam(by: team)
            return
        }
    }
    
    
}

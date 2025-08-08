//
//  EventItemView.swift
//  SportsDB
//
//  Created by Macbook on 30/5/25.
//

import SwiftUI

struct EventItemView<OptionView: View>: View {
    @Binding var isVisible: Bool
    var delay: Double
    
    var event: Event
    var optionView: (Event) -> OptionView
    //var homeTeamTapped: (Event) -> Void
    //var awayTeamTapped: (Event) -> Void
    
    var tapOnTeam: (Event, KindTeam) -> Void
    var eventTapped: (Event) -> Void
    
    var body: some View {
        VStack {
            switch SportType(rawValue: event.sportName ?? "")?.competitionFormat {
            case .teamVsTeam:
                Sport2vs2EventItemView(isVisible: $isVisible, delay: delay, event: event, optionView: optionView, tapOnTeam: tapOnTeam)
            case .oneVsOne, .teamVsTeams, .doubles, .freeForAll, .multiFormat:
                SportSingleEventItemView(event: event, optionView: optionView, eventTapped: eventTapped)
                //EmptyView()
            case .none:
                EmptyView()
            case .some(.oneVsMany):
                EmptyView()
            case .some(.relay):
                EmptyView()
            }
        }
    }
}



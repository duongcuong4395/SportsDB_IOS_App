//
//  ListEventView.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import SwiftUI

struct ListEventView<OptionEventView: View>: View {
    var events: [Event]
    @State private var showModels: [Bool] = []
    @State private var repeatAnimationOnApear = false
    var optionEventView: (Event) -> OptionEventView
    var tapOnTeam: (Event, KindTeam) -> Void
    var eventTapped: (Event) -> Void
    
    var body: some View {
        VStack {
            if events.count > 3 {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 15) {
                        ForEach(Array(events.enumerated()), id: \.element.idEvent) { index, event in
                            EventItemView(
                                isVisible: $showModels.indices.indices.contains(index) ?
                                $showModels[index] : .constant(false),
                                delay: Double(index) * 0.01,
                                
                                event: event,
                                optionView: optionEventView,
                                tapOnTeam: tapOnTeam,
                                eventTapped: eventTapped)
                            .rotateOnAppear()
                            .onAppear{
                                guard showModels[index] == false else { return }
                                withAnimation {
                                    showModels[index] = true
                                }
                            }
                            .onDisappear{
                                guard showModels[index] == true else { return }
                                if repeatAnimationOnApear {
                                    self.showModels[index] = false
                                }
                                
                            }
                        }
                    }
                }
            } else {
                LazyVStack(spacing: 15) {
                    ForEach(Array(events.enumerated()), id: \.element.idEvent) { index, event in
                        EventItemView(
                            isVisible: $showModels.indices.indices.contains(index) ?
                            $showModels[index] : .constant(false),
                            delay: Double(index) * 0.01,
                            
                            event: event, optionView: optionEventView,
                            //homeTeamTapped: homeTeamTapped, awayTeamTapped: awayTeamTapped,
                            tapOnTeam: tapOnTeam,
                            eventTapped: eventTapped)
                            .rotateOnAppear()
                            
                    }
                }
            }
        }
        .onAppear{
            withAnimation {
                if showModels.count != events.count {
                    self.showModels = Array(repeating: false, count: events.count)
               }
            }
            
        }
        
    }
}

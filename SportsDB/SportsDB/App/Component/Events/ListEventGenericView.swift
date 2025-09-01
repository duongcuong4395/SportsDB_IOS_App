//
//  ListEventGenericView.swift
//  SportsDB
//
//  Created by Macbook on 1/9/25.
//

import SwiftUI

struct ListEventGenericView<Builder: ItemBuilder>: View where Builder.T == Event {
    var events: [Event]
    @State private var showModels: [Bool] = []
    @State private var repeatAnimationOnApear = false
    
    var itemBuilder: Builder
    var onEvent: (ItemEvent<Event>) -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            if events.count > 3 {
                ScrollView(showsIndicators: false) {
                    listEventView
                }
            } else {
                listEventView
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
    
    var listEventView: some View {
        LazyVStack(spacing: 10) {
            ForEach(Array(events.enumerated()), id: \.element.idEvent) { index, event in
                EventItemGenericView(
                    event: event
                    , isVisible: $showModels.indices.indices.contains(index) ?
                    $showModels[index] : .constant(false)
                    , delay: Double(index) * 0.01
                    , itemBuilder: itemBuilder
                    , onEvent: onEvent)
                .rotateOnAppear()
                .onAppear{
                    guard showModels[index] == false else { return }
                    withAnimation {
                        showModels[index] = true
                    }
                    onEvent(.onApear(for: event))
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
}

//
//  EventOptionsView.swift
//  SportsDB
//
//  Created by Macbook on 2/6/25.
//

import SwiftUI

struct EventOptionsView: View, ItemDelegate {
    
    var event: Event
    var onAction: (EventAction, Event) -> Void   // ✅ only ONE closure needed
    
    var body: some View {
        HStack(spacing: 30) {
            if let awayTeamName = event.awayTeam {
                if event.homeTeam != "" && event.awayTeam != "" {
                    if event.homeScore == nil {
                        event.getBtnViewDetail(with: self, type: .MultiStar)
                            .foregroundStyle(.blue)
                    }
                }
            }
            
            
            let now = Date()
            
            if let dateTimeOfMatch = DateUtility.convertToDate(from: event.timestamp ?? "") {
                if now < dateTimeOfMatch {
                    event.getBtnNotify(with: self)
                }
            }
            
            if event.video?.isEmpty == false {
                event.getBtnOpenVideo(with: self)
            }
            event.getBtnFavorie(with: self)
        }
    }
    
    func performAction<T>(_ action: EventAction, for model: T) where T : Equatable {
        guard let model = model as? Event else { return }
        onAction(action, model)
    }
}

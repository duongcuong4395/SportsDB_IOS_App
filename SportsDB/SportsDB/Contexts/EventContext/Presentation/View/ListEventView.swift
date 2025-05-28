//
//  ListEventView.swift
//  SportsDB
//
//  Created by Macbook on 27/5/25.
//

import SwiftUI

struct ListEventView: View {
    var events: [Event]
    var body: some View {
        List {
            ForEach(events, id: \.idEvent) { event in
                HStack {
                    VStack {
                        Text(event.eventName)
                        Text(event.leagueName)
                    }
                    Spacer()
                    VStack {
                        HStack {
                            Text(event.homeTeam)
                            Text(event.homeScore)
                        }
                        HStack {
                            Text(event.awayTeam)
                            Text(event.awayScore)
                        }
                    }
                }
            }
        }
    }
}
